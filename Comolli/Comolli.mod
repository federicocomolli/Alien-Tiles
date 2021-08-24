#SET

set T; #49 tiles
set R{0..6} within T;
set C{0..6} within T;

#PARAMS

param r{T}; #row of each tiles
param c{T}; #column of each tiles

#VARS

#how many times each tile has been RED
var XR{t in T} integer, >=1;    #each tile starts from color red
#how many times each tile has been GREEN
var XG{t in T} integer, >=0;
#how many times each tile has been BLUE
var XB{t in T} integer, >=0;
#how many times each tile has been PURPLE
var XP{t in T} integer, >=0;
#how many times each tile has been clicked
var Y{t in T} integer, >=0;

#OBJECTIVE FUNCTION 

minimize tot_clicks:
	 sum{t in T} Y[t]; 
	 
#CONSTRAINTS

#each tile has changed colors each time that any tile in the same row or column has been clicked(including it)
subject to constr1{t in T}:
	(XR[t]-1+XG[t]+XB[t]+XP[t]) = (sum{i in R[r[t]]}(Y[i]) + sum{j in C[c[t]]}(Y[j]) - Y[t]);
	
#I want that all tiles become green	
subject to constr2{t in T}:
	XR[t] = XG[t];
subject to constr3{t in T}:
	XG[t]-1 = XB[t];
subject to constr4{t in T}:
	XB[t] = XP[t];
	
#During the lesson, the professor suggested us to add some further constraints to "break the symmetries" and, consequently,
#to exclude some solution that is not optimal.
#I studied the 7x7 matrix and I noticed that when I click on a tile, every tile of the same row and of the same column
#changes its color. 
#Focusing on a row, it's not relevant for the solution how many times I click on each tile, but it's important the sum on the whole row.
#The same is true also for each column. So I added the following constraints to reduce the computation time of the problem:
	
subject to constr5{t in T, i in T : ((r[t]=r[t]) and (c[t]>=c[i]))}:
	Y[t]<=Y[i];
	
subject to constr6{t in T, i in T : ((c[t]=c[i]) and (r[t]>=r[i]))}:
	Y[t]<=Y[i];
