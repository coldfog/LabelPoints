LabelPoints
===========

It's a matlab GUI program for labeling points on image.


Usage
=====

Labeling
--------

Run labelPoints.m.
Enter the name of the folder which contains your images waiting for labeling. Then open it.

The result file will be automatically generated in the folder your opened with name 'result.mat'.

Reading data
------------

`load 'result.mat'`

result(i).I is the image you labeled.

result(i).Points is the Points you labeled.
