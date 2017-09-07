# Cube2Video

What is Cube2Video?
----------------

The Cube2Video package gives a matlab implementation of the algorithm introduced in "Cube2Video: Navigate Between Cubic Panoramas in Real-Time" by Zhao et al. This algorithm takes a few cubic panoramas as input and synthesizes a smooth panoramic video through view interpolation. Please note that our original implementation is written using C and CUDA. The package here just gives a demonstration. It also does not consider the shaking problem handled in Section IV of our paper. 

Conditions of use
-----------------

This package is distributed under the GNU General Public License.  For information on commercial licensing, please contact the authors.

If you use this package in published work, please cite our paper as
```
@article{zhao-2013-cube2video,
    author   = {Qiang Zhao and Liang Wan and Wei Feng and Jiawan Zhang and Tien-Tsin Wong},
    title    = {Cube2Video: Navigate between Cubic Panoramas in Real-Time},
    journal  = {IEEE Transactions on Multimedia},
    year     = {2013},
    volume   = {15},
    number   = {8},
    pages    = {1745-1754},
```



Run instructions
---------------
You should first get the SIFT feature extractor from [David Lowe](http://www.cs.ubc.ca/~lowe/keypoints/). The code for spherical Delaunay triangulation is also need, which can be downloaded from [John Burkardt](http://people.sc.fsu.edu/~jburkardt/m_src/m_src.html). Then you can run 'tDemo.m'.
