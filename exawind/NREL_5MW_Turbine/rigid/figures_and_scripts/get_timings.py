#!/usr/bin/env python3

import subprocess as sp
import os,sys
import numpy as np 
import json
import ruamel.yaml
import argparse
import pathlib
import pandas as pd
import re
import time
import glob
from collections import OrderedDict
import matplotlib
import matplotlib.pyplot as plt


def find_line(lookup,filename):
    linelist = []
    with open(filename) as myFile:
        for num, line in enumerate(myFile, 1):
            if lookup in line:
                linelist.append(num)
    return linelist

def get_closest_row(df, column, value):
    """Get the row in a DataFrame that is closest to a given value in a specific column."""

    # Calculate the absolute difference between the column values and the target value
    df['diff'] = abs(df[column] - value)

    # Find the index of the row with the smallest difference
    min_index = df['diff'].idxmin()

    # Return the row with the smallest difference
    return df.loc[min_index]

def get_times_netcdf(filepath):
    cmd = 'ncdump -v time_whole ' + filepath + ' | sed -e "1,/data:/d" -e "$d"'
    result = sp.run(cmd, shell=True, capture_output=True, text=True)

    stdout = result.stdout
    retstring = ''

    for line in stdout.splitlines():
        templine = line.strip()
        retstring = retstring + templine
            
    retstring = re.sub(r'\s+', '', retstring)
    retstring = retstring.replace(';}','').replace('time_whole=','').split(',')

    return [float(s) for s in retstring]

def read_openfast_input(offile,ofvariable,vartype):

    # Regex to match any continuous non-whitespace
    allreg = "\S+"

    # Regex to match any continuous whitespace
    spreg = "\s+"

    search_text = allreg + spreg + re.escape(str(ofvariable).strip())

    textfile = open(offile, 'r')
    filetext = textfile.read()
    textfile.close()
    matches = re.findall(search_text, filetext)

    if(vartype=="str"):
        return matches[0].split()[0]
    else:
        return float(matches[0].split()[0])


def read_openfast_output(file_dir, file_name, skip_time, dt_out):

    file_loc = os.path.join(file_dir,file_name)

    initial_skip_steps = int(skip_time/dt_out)
    headskip = [0,1,2,3,4,5,7]
    
    for s in find_line('#Restarting here',file_loc):
        headskip.append(s-1)

    largeskip = list(range(8,initial_skip_steps+8))

    this_data = pd.read_csv(file_loc,sep='\s+',skiprows=(headskip+largeskip), header=(0),skipinitialspace=True, dtype=float)
    print('Reading',file_loc,sys.getsizeof(this_data),'bytes')
    return this_data

def read_yaml(filepath):
    with open(filepath, 'r') as file:
        yaml = ruamel.yaml.YAML()
        data = dict(yaml.load(file))
    return data

def read_amr(filepath):
    returndict = OrderedDict()
    with open(filepath) as f:
        for line in f:
            key, data = processline(line)
            if key is not None: returndict[key] = data
    return returndict

def processline(inputline):
    line = inputline.partition('#')[0]
    line = line.rstrip()
    if len(line)>0:
        line = line.split('=')
        key  = line[0].strip()
        data = line[1].strip()
        return key, data
    return None, None


def main():

    casedir = '/pscratch/ndeveld/hfm-2025-q1'
    casename = 'rigid_abl_splitmsh_nate2'
    casepath = os.path.join(casedir,casename)

    plotdir = os.path.join(casepath,'plots')

    exlogfile = casepath+"/log"
    amrlogfile = casepath+"/nrel5mw_amr.log"
    nalulogfile = casepath+"/nrel5mw_nalu.log"
    prefix = 'rign2'

    #cmd="grep '^Exawind::Total' "+exlogfile+" | awk '{print $3}' > "+casepath+"/exatimestep.dat"
    #result = sp.run(cmd, shell=True, capture_output=True, text=True)

    cmd="grep '^Exawind::Total' "+exlogfile+" | awk '{print $3}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    total_timesteps = [float(x) for x in result.stdout.replace('\n',' ').split()]

    cmd="grep '^Nalu-Wind-1::Total' "+exlogfile+" | awk '{print $3}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    nalu_timesteps = [float(x) for x in result.stdout.replace('\n',' ').split()]

    cmd="grep '^AMR-Wind::Total' "+exlogfile+" | awk '{print $3}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    amr_timesteps = [float(x) for x in result.stdout.replace('\n',' ').split()]

    cmd="grep '^  MAC_projection ' "+amrlogfile+" | awk '{print $2}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    amr_mac= [float(x) for x in result.stdout.replace('\n',' ').split()]

    cmd="grep '^  Nodal_projection ' "+amrlogfile+" | awk '{print $2}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    amr_nodal= [float(x) for x in result.stdout.replace('\n',' ').split()]

    cmd="grep '^        MomentumEQS ' "+nalulogfile+" | awk '{print $2}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    nalu_mom= [float(x) for x in result.stdout.replace('\n',' ').split()]

    cmd="grep '^        ContinuityEQS ' "+nalulogfile+" | awk '{print $2}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    nalu_cont= [float(x) for x in result.stdout.replace('\n',' ').split()]


    #tsdata = pd.read_csv(casepath+'/avgtimestep.dat',header=None)
    ts = range(len(total_timesteps))
    nts = range(len(nalu_timesteps))
    ats = range(len(amr_timesteps))
    amrts = range(len(amr_mac)) 
    naluts = range(len(nalu_mom))
    conts =  range(len(nalu_cont))

    print('Mean timestep',np.mean(total_timesteps))

    # Get AMR Cells
    cmd="grep '  Level' "+amrlogfile+" | awk '{print $5}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)

    cellarray = []

    for line in result.stdout.splitlines():
        templine = line.strip()
        cellarray.append(int(templine))

    amr_cells = np.sum(np.array(cellarray))

    print('AMR cells',amr_cells)

    # Get Nalu Cells
    cmd="grep '^Node count' "+nalulogfile+" | awk '{print $7}'"
    result = sp.run(cmd, shell=True, capture_output=True, text=True)
    nalu_cells = int(result.stdout)

    print('Nalu cells',nalu_cells)

    print('Total cells',amr_cells+nalu_cells)

    print('Mean Timestep per cell',np.mean(total_timesteps)/(amr_cells+nalu_cells))

    cs = 5  # Plot the 5th occurence of continuity iters
    ms = 4  # Plot the 4th occurence of momentum iters

    nmd_filt = np.array(nalu_mom)[0::ms].copy()
    ncd_filt = np.array(nalu_cont)[0::cs].copy()
    nmts_filt = np.arange(len(nmd_filt))
    ncts_filt = np.arange(len(ncd_filt))
    
    # Plot main exawind
    plt.rcParams.update({'font.size': 18})

    fig, ax = plt.subplots(1,3,figsize=(13,4))
    ax[0].scatter(ts,total_timesteps,s=0.3)
    ax[0].set_title('Exawind')
    ax[1].scatter(nts,nalu_timesteps,s=0.3)
    ax[1].set_title('Nalu-Wind')
    ax[2].scatter(ats,amr_timesteps,s=0.3)
    ax[2].set_title('AMR-Wind')

    for i in range(3):
        ax[i].set_ylabel('Time (s)')
        ax[i].set_xlabel('Timestep')
        ax[i].set_ylim([0,20])

    fig.tight_layout()
    fig.savefig('timepertimestep.png')

    # Plot AMR
    plt.rcParams.update({'font.size': 18})

    in_min = min(len(amrts),len(amr_nodal))-1

    fig, ax = plt.subplots(1,2,figsize=(13,4))
    ax[0].scatter(amrts[0:in_min],amr_mac[0:in_min],s=0.3,label="AMR MAC Projection")
    ax[0].scatter(amrts[0:in_min],amr_nodal[0:in_min],s=0.3,label="AMR Nodal Projection")
    ax[0].set_title('AMR-Wind')

    ax[1].scatter(nmts_filt,nmd_filt,s=0.3,label="Nalu Momentum")
    ax[1].scatter(ncts_filt,ncd_filt,s=0.3,label="Nalu Continuity")
    ax[1].set_title('Nalu-Wind')

    for i in range(2):
        ax[i].set_ylabel('N')
        ax[i].set_xlabel('Timestep')
        ax[i].legend()
        ax[i].set_ylim([0,50])

    fig.tight_layout()
    fig.savefig('iters.png')


    


if __name__ == "__main__":
    main()