

# TU Delft DU00-W-212 airfoil

Validation of the transition model is conducted for the DU00-W-212 airfoil airfoil using Nalu-Wind with the 1-equation gamma transition model. A full angle-of-attack sweep was performed, and the results are compared against the experimental data[^1] and fully tubulent simulation results.

## Simulation Conditions

- Test airfoil: DU00-W-212 airfoil with a thickness of 21% 
- Flow Condition: M=0.1, Re=3million, Tu=0.0864%
- CFD mesh generated using Pointwise 
  - 2-D structred O-type mesh, with a resolution equivalent to the "Fine" resolution of the AIAA mesh
- Turbulence / Transition model: SST-2003 with the 1-eq Gamma transition model with µt/µ=1
- Nalu-Wind version: [6155b17fa6b8914a819a492230c96f7990a97b78](https://github.com/Exawind/nalu-wind/commit/6155b17fa6b8914a819a492230c96f7990a97b78)


## Results: Angle of Attack Sweep

### Comparison of the lift, drag, and pitching moment
<img src="figs/du_rey_3M.png" alt="Cf" width="600">

The figure above shows comparisons of the lift, drag, and pitching moment from the experiment, fully turbulent simulations, and transition simulations.

For the lift coefficient, both the fully turbulent and transition simulations show good agreement with the experimental data in the linear range. The transition simulation predicts a slightly higher lift curve slope than the fully turbulent simulation in this range, but the differences are minor. However, neither the transition nor turbulent simulations accurately predict the stall angle of attack due to the limitations of RANS modeling under strong adverse pressure gradients.

For the drag coefficient, the transition simulation captures the laminar drag bucket very well, whereas the fully turbulent simulation overpredicts drag across the entire linear range. At AoA = 0°, the errors in the predicted drag coefficient for the transition and turbulent simulations are -4.35% and 58.81%, respectively. Without the transition model, drag is over-predicted by almost 60%.

Regarding the pitching moment, the transition simulations show better correlation with the experimental data compared to the fully turbulent simulations in the linear range of the lift curve. After the stall AoA, due to the limitations of the RANS turbulence model, neither simulation captures the pitching moment trends accurately, with both under-predicting the magnitude in the post-stall region.

In summary, the transition model primarily improves drag prediction at low angles of attack before flow separation occurs.

## References
[^1]: https://zenodo.org/records/439827