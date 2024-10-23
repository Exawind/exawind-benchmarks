

# TU Delft DU00-W-212 airfoil

Validation of the transition model is conducted for the DU00-W-212 wind turbine airfoil using Nalu-Wind with the 1-equation gamma transition model. A full angle-of-attack sweep was performed, and the results are compared against the experimental data[^1] and fully tubulent simulation results.

## Simulation Conditions

- Test airfoil: DU00-W-212 airfoil with a thickness of 21% 
- Flow Condition: M=0.1, Re=3million, Tu=0.0864%
   - U<sub>∞</sub>=34.1m/s, ρ=1.225kg/m<sup>3</sup>, µ<sub>t</sub>/µ=1
   - k<sub>∞</sub>=0.0013020495206400003, ω<sub>∞</sub>=114.54981120000002
- CFD mesh generated using Pointwise 
   - 2-D structured O-type mesh, with a resolution equivalent to the "Fine" resolution of the AIAA mesh
- Turbulence / Transition model: SST-2003 with the 1-eq Gamma transition model
- Nalu-Wind version: [f3cecafbdc05e61d0550ff41a30307425ef8197b](https://github.com/Exawind/nalu-wind/commit/f3cecafbdc05e61d0550ff41a30307425ef8197b)

## Results: Angle of Attack Sweep

### Comparison of the lift, drag, and pitching moment
<img src="figures_and_scripts/du_rey_3M.png" alt="Cf" width="1000">

The figures above show comparisons of the lift, drag, and pitching moment from the experiment, fully turbulent simulations, and transition simulations.

For the lift coefficient, both the fully turbulent and transition simulations show good agreement with the experimental data in the linear range. The transition simulation predicts a slightly higher lift curve slope than the fully turbulent simulation in this range, but the differences are minor. However, neither the transition nor turbulent simulations accurately predict the stall angle of attack due to the limitations of RANS modeling under strong adverse pressure gradients.

For the drag coefficient, the transition simulation captures the laminar drag bucket very well, whereas the fully turbulent simulation overpredicts drag across the entire linear range. At AoA = 0°, the errors in the predicted drag coefficient for the transition and turbulent simulations are -4.35% and 58.81%, respectively. Without the transition model, the drag is over-predicted by almost 60%.

Regarding the pitching moment, the transition simulations show better correlation with the experimental data compared to the fully turbulent simulations in the linear range of the lift curve. After the stall AoA, due to the limitations of the RANS turbulence model, neither simulation captures the pitching moment trends accurately, with both under-predicting the magnitude in the post-stall region.

In summary, the transition model significantly improves the prediction of the aerodynamic coefficeints in the linear range.

In this simulation, each case took approximately 30 minutes to 10,000 iterations, using 4 Picard iterations per time step, on 26 cores of NREL's Kestrel HPC cluster. It should be noted that the number of cores per case was not determined by Nalu-Wind’s scalability on Kestrel, but simply to accommodate 4 cases on a single node of Kestrel. For more details, refer to the Nalu-Wind log files in the run directory.

[^1]: https://zenodo.org/records/439827
