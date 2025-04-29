#!/usr/bin/env python3

from subprocess import call
import os,sys
import numpy as np 
import json
import ruamel.yaml as yaml
import argparse
import pathlib
from scipy.interpolate import interp1d
import pandas as pd
import re
import matplotlib
import matplotlib.pyplot as plt
import importlib
import time
import glob

#ofparamhome = os.environ.get('OPENFAST_PARAM')
#sys.path.append(ofparamhome + '/import')
#import plot_func as pf
#importlib.reload(sys.modules['plot_func'])

def find_line(lookup,filename):
    linelist = []
    with open(filename) as myFile:
        for num, line in enumerate(myFile, 1):
            if lookup in line:
                linelist.append(num)
    return linelist

def get_bounds(data,time,azmin,azmax):
    tmax = np.max(time)
    dt = tmax/len(time)
    xmin = azmin - 20.0
    xmax = np.max(time)+5.0
    dplot = int(np.floor((tmax - xmin)/dt))
    ybmax = np.max(np.array(data[-dplot:-2]))
    ybmin = np.min(np.array(data[-dplot:-2]))
    ymin = ybmin-ybmin*0.08
    ymax = ybmax+ybmax*0.08
    if (ybmax < 0.2 and ybmin > -0.2):
        ymax = 0.2
        ymin = -0.2
    
    return xmin,xmax,ymin, ymax

def main():
    parser = argparse.ArgumentParser(description="Quickly plot and display openfast output")
    parser.add_argument(
        "-d",
        "--directory",
        help="Parent directory with case folders",
        required=False,
        type=str,
        default="",
    )

    args = parser.parse_args()

    case_list = ['rigid_abl_splitmsh_nate2']
    force_file_names = ['forcesBlades.dat']
    case_lab = ['NREL 5MW Rigid']

    omega = 1.26710903694788
    diffn = 60000
    rotaxis = [0.862729916,0.498097349,-0.087155742]

    matplotlib.rcParams['font.size'] = 16

    fig = plt.figure(constrained_layout=True,figsize=(12,4))
    subfigs = fig.subfigures(nrows=1, ncols=1)
    ax = subfigs.subplots(nrows=1, ncols=3)

    for i,c in enumerate(case_list):

        print('Processing: ',c)

        this_data = []

        for j in range(len(force_file_names)):
            fullpath = os.path.join(args.directory,c,force_file_names[j])
            print(fullpath)

            this_data.append(pd.read_csv(fullpath,sep='\s+',skipinitialspace=True))

        yawangle = 30.0*np.pi/180.0
        tiltangle = 5.0*np.pi/180.0


        all_data = pd.concat(this_data, ignore_index=True)


        all_data['fx'] = all_data['Fpx']+all_data['Fvx']
        all_data['fy'] = all_data['Fpy']+all_data['Fvy']
        all_data['fz'] = all_data['Fpz']+all_data['Fvz']

        all_data['frot30x'] = all_data['fx']*np.cos(-yawangle)-all_data['fy']*np.sin(-yawangle)
        all_data['frot30y'] = all_data['fx']*np.sin(-yawangle)+all_data['fy']*np.cos(-yawangle)
        all_data['frot30z'] = all_data['fz']       

        all_data['mrot30x'] = all_data['Mtx']*np.cos(-yawangle)-all_data['Mty']*np.sin(-yawangle)
        all_data['mrot30y'] = all_data['Mtx']*np.sin(-yawangle)+all_data['Mty']*np.cos(-yawangle)
        all_data['mrot30z'] = all_data['Mtz']

        all_data['Torque'] = (all_data['mrot30x']*np.cos(-tiltangle)+all_data['mrot30z']*np.sin(-tiltangle))/1000
        all_data['Thrust'] = (all_data['frot30x']*np.cos(-tiltangle)+all_data['frot30z']*np.sin(-tiltangle))/1000

        all_data['Power'] = all_data['Torque']*omega*0.944

        ax[0].plot(all_data['Time'], all_data['Thrust'], label=case_lab[i])
        ax[0].set_xlabel("Time [s]")
        ax[0].set_ylabel("Thrust [kN]")

        ax[1].plot(all_data['Time'], all_data['Torque'], label=case_lab[i])
        ax[1].set_xlabel("Time [s]")
        ax[1].set_ylabel("Torque [kN-m]")

        ax[2].plot(all_data['Time'], all_data['Power'], label=case_lab[i])
        ax[2].set_xlabel("Time [s]")
        ax[2].set_ylabel("Power [kW]")

    mean_data = all_data[all_data['Time']>30.0].mean()

    print('Mean Power: ',mean_data.Power,'kW')
    print('Mean Thrust: ',mean_data.Thrust,'kN')
    print('Mean Torque: ',mean_data.Torque,'kN-m')


    plt.savefig('rigid_output.png')
    plt.close()

if __name__ == "__main__":
    main()

