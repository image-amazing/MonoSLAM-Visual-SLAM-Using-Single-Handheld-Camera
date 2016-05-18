# EECS 568 W16 Project


## 
Dependencies

- MATLAB Computer Vision Toolbox

## 

1. In order to execute the files, please download the dataset from gdrive [https://drive.google.com/a/umich.edu/file/d/0B9ZsJlYrNko9Rl9TU0VaWGhQZ3c/view?usp=sharing].

2. To acquire from the dataset, change its current location depending on your directory
Make changes in file: 
init_mono_params.m - Line 32 Change "Param.frame.dir"

2.Run

- The main script for monoslam is in monoslam/runmonoslam.m.
- 
To run the entire program type: " run (500, 'mono', 0.01) "

3.Parameters that can be changed depending on the dataset:
init_mono_params.m - Change variables 

"Param.frame.ext" - Depends on file extension (.jpg,.png)
"Param.frame.end_id" - Depends on total number of frames/images in the dataset
"Param.frame.stride" - Change the stride at which images are read from the dataset
"Param.map.min_nL" - Change the minimum number of landmarks that must be matched & detected in the image
"Param.rho_init" - Change inverse depth initialization value
"Param.dt" - Change time between frames (Depends on frame rate)
"Param.patchsize_match" - Change patch size required for matching
Other Noise parameters can also be changed

4. Intrinsic Camera Parameters may need to be changed depending on the dataset
get_camera_params.m - Change variables

fx   - focal length x
fy   - focal length y
Cx   - optical center x
Cy   - optical center y

5. To stop visualizing any plots or trajectory

 

init_mono_params.m - Change variables

Param.do_visualize = false

6. To stop saving plots for the trajectory
init_mono_params.m - Change variables

Param.do_save = false












## Analytic computation of Jacobian

- compute_analytic_exp.m

