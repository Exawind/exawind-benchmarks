

# NREL Phase VI Rotor

ExaWind simulations are performed for NREL’s Unsteady Aerodynamics Experiment Phase VI rotor. The experimental conditions are summarized below:

- Tested in the 80 X 120 ft wind tunnel at NASA Ames Research Center (M. H. Hand et al, 2001)
- Two bladed rotor with a diameter of 10.529 m 
- Fixed tip speed, 72 RPM
- Blade section: single airfoil, S809, from r/R=0.25 
- Nonlinear twist with blade tip pitch of 3deg
- Pitch and twist axis at 0.3c
- Maximum Reynolds number on the blade section: around 1 million

# Simulation Setup
- Turbulence / Transition model: SST-2003 with the 1-eq Gamma transition model
- ExaWind driver version: [a38a4d5f96e4d3b42b52f41280e2d8d28c57ef25]( https://github.com/Exawind/exawind-driver/commit/a38a4d5f96e4d3b42b52f41280e2d8d28c57ef25)
- Nalu-Wind version: [f3cecafbdc05e61d0550ff41a30307425ef8197b](https://github.com/Exawind/nalu-wind/commit/f3cecafbdc05e61d0550ff41a30307425ef8197b)
- AMR-Wind version: [8bad127f62cf2fd2f0d0ae16f2df47fdd0d069f8]( https://github.com/Exawind/amr-wind/commit/8bad127f62cf2fd2f0d0ae16f2df47fdd0d069f8)  


# Freestream conditions

Simulations are performed for both fully turbulent and laminar-turbulent transition conditions at two wind speeds: 7 m/s and 15 m/s, which represent speeds below and above the rated wind speed, respectively.

The tunnel’s turbulence intensity was reported to be below 0.5%, but the precise measurement was unavailable during the experiments. In this work, a turbulence intensity of 0.1% was assumed, which is typical for wind tunnels. The freestream conditions for the k and ω account for the decay of turbulent variables from the input to the blade, with the inlet set 100m upstream of the rotor. The conditions are as follows:

- Inflow conditions at 7 m/s
    - U<sub>∞</sub>=7.0m/s, ρ=1.246kg/m<sup>3</sup>, µ<sub>t</sub>/µ=4.5
    - k<sub>∞</sub>= 0.007350, ω<sub>∞</sub>= 115.044281

- Inflow conditions at 15 m/s
    - U<sub>∞</sub>=15.0m/s, ρ=1.246kg/m<sup>3</sup>, µ<sub>t</sub>/µ=9.7
    - k<sub>∞</sub>=0.033750, ω<sub>∞</sub>=245.071186

# CFD mesh generation

The near-body Nalu-Wind mesh was created using Pointwise from the CAD model. The two blades are connected with a cylinder at the center, while other components such as the spinner or tower were not included in the CFD model.
- Mesh topology: O-O typed structured mesh
- 500 points in the chordwise direction
- Initial wall normal spacing: 5e-6m
- Size of the overset boundaries: 1.5m
- Wall normal growth rate: 1.15 
- Total cell counts: 23,192,978

Off body 
AMR-Wind mesh is generated using the built-in capability of AMR-Wind. Off-body mesh information is summarized below 
- Mesh topology: Carstensen with AMR
- Domain in x= -100 to 150m, y=-100m to 100m, z=-100m to 100m
- Initial grid size: 0.78125m
- Finest cell size: 0.1953 m with 4 AMR levels
   - See detail ranges of the mesh refinement in “static_box.txt”
- Total cell counts: 45,527,040

# Results

The rotor simulations are performed in the four sequential stages as below
- Rev. 1 and 2: 0.25deg
- Rev. 3 and 4: 0.125deg
- Rev. 5 and 6: 0.0625 deg
- Rev. 7 and 8: 0.03125 deg 

This is particulary important for the wind speed of 15m/s, which has the sectional angle of attac distribution between 15 and 35 deg with massively separated flow

The figure compares the rotor performance at 7m/s and 15m/s, thrust and torque against the experimental data and available numerical results. 

<img src="figs/pPhaseVi.png" alt="Cf" width="1000">


