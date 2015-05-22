;; The model relies on the gis and table extensions to Netlogo
extensions [ gis table array profiler bitmap]; bitmap takes a screenshot of view

;; The model is divided into several .nls files; each captures a separate aspect of the model
__includes 
[ "nls/VariableNames.nls"        ;contains all global and patch variables
  "nls/CalculateHSI.nls"         ;calculates global SI
  "nls/CalculateEnvironSI.nls"   ;calculates SI values for enviornmental parameters
  "nls/SetGlobalEnvironment.nls" ;sets the global environments (Temp procedure until we get real data) 
  "nls/BoaterBehavior.nls"       ;calculates likelihood of boaters moving from patch i to patch j
  "nls/CalculateDistance.nls"    ;test module for looping through distances
  "nls/CalculateFrequency.nls"   ;calculates frequency of most attractive sites
  "nls/CalceBoatZebeDisp.nls"    ;calculates probability of boats transporting Zebra mussels to each cell
  "nls/Dispersal_logistic.nls"   ;calculates probability of zebra mussel dispersal based on surface area and zebra mussel presence
  "nls/import-cvs-data.nls"
  "nls/calendar.nls"             ;calendar module
  "nls/createturtles.nls"        ;creates turtles and breeds
 ]

breed [zebra-mussels zebra-mussel]

;test test Git hub test
;test test again


breed [boats boat]
 


to setup
                                     
 ca 
 set day 0
 set month "January"
 set year 1
 
 
 random-seed 13
  set-status
  set-global-environment 
  make-turtles
  color-boats
  calculate-parameters-boater
  calc-distance 
  calculate-constrained-gravity
  calculate-most-frequent-destination
  boat-zebe-dispersal
  highlight-infected-boats
  bitmap:export bitmap:from-view "Screenshot"  ; takes a screenshot of the view, bitmap file named Screenshot, quality of image is better this way. 
  ;highlight
; print timer
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Print some debugging       ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
  
  if file-exists? "TestOutput-ZM.csv"   [ file-delete "TestOutput-ZM.csv" ]
  file-open "TestOutput-ZM.csv"
  file-print (word "output")
  ask patches [
       file-write (word pxcor " " pycor " " patch-elevation " "  patch-salinity " " patch-TSS )
  ]
  file-close
 ; Show "done" ;TELLS YOU WHEN DATA ARE FINISHED OUTPUTTING   
  import-csv-data "Inputs ZM/ZM1985_reefavgday USE.csv"     
  reset-ticks
  reset-timer
  
end ;setup

to go
  
  tick
  calendar
  update-patches
  updater
  ask boats [update-infected-status]
  move
  boat-zebe-dispersal
  highlight-infected-boats
  color-boats                               ;consolidated this code into a procedure in CreateTurtles.nls
  calculate-hsi
  
  if year > years-to-simulate [stop]         ; just sets the number of years to simulate, user defined on interface
  
end ;go



to update-infected-status; begin updating boat infected status
  set boat-id who
  color-boats  ;consolidated this code into a procedure in CreateTurtles.nls
  
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;Code to move boats from patch i to patch j;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
  ifelse one-of r > 0.1 [set boat-r max r ][set boat-r 0]
    ask boats [set destination-patch one-of patch-id]
    ask boats [move-to destination-patch]

end; end updating infected status

to update-patches
end 

to updater; begin updater
;  ask patches with [patch-habitat-type = "water" ][
;   set salinity-update (item (ticks - 1) [salinity-list] of this-reef) ; this sets the imported salinity data to the patch variable salinity-update
;   set depth-update (item (ticks - 1) [depth-list] of this-reef)
;   set TSS-update (item (ticks - 1) [TSS-list] of this-reef)
;   set Temp-update (item (ticks - 1) [Temp-list] of this-reef)
;   set DO-update (item (ticks - 1) [DO-list] of this-reef)
;    set patch-elevation depth-update                                                       ; this sets the imported elevation data to the patch elevation variable
;    set salinity salinity-update                                                     ; this sets the imported salinity data to the patch salinity variable
;    set patch-TSS TSS-update                                                               ; this sets the imported TSS data to the patch TSS variable
;    set patch-temp Temp-update                                                      ; this sets the imported temperature data to the patch temperaturevariable
;    set patch-DO DO-update                                                                 ; this sets the imported DO data to the patch DO variable 
; ]

end ; end updater

  
to count-neighbors
 set total-neighbor-state count (neighbors with [pcolor = orange or pcolor = red]) 
  
end ;count neighbors

to move; begin move
  ask turtles with [shape = "boat"] [ ifelse patch-habitat-type = "water" and can-move? 0.3 [fd 0.1 ][bk 0.4 stop]]
      ;move-to one-of (patch-set patch-here neighbors in-radius 10) with [patch-habitat-type = "water"] ; can move to water body patch randomly
   ;]  
end ; end move
@#$#@#$#@
GRAPHICS-WINDOW
347
14
888
576
-1
-1
25.3
1
10
1
1
1
0
0
0
1
0
20
0
20
0
0
1
ticks
30.0

BUTTON
38
32
105
65
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
122
33
185
66
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
122
89
185
122
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
43
229
215
262
number-not-infected?
number-not-infected?
0
50
50
1
1
NIL
HORIZONTAL

INPUTBOX
37
140
192
200
number-of-boats
1
1
0
Number

SLIDER
28
274
225
307
number-infected?
number-infected?
0
50
5
1
1
NIL
HORIZONTAL

INPUTBOX
208
139
305
199
Num-Env-Variables
12
1
0
Number

SLIDER
52
323
224
356
years-to-simulate
years-to-simulate
0
100
5
1
1
NIL
HORIZONTAL

TEXTBOX
6
684
594
740
if Ammonia < Ammonia1 and Ammonia-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
6
781
606
837
if Ammonia < Ammonia1 and Ammonia-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

TEXTBOX
3
883
611
953
if Ammonia >= Ammonia1 and Ammonia <= Ammonia2 and Ammonia-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

TEXTBOX
32
991
648
1061
if Ammonia >= Ammonia1 and Ammonia <= Ammonia2 and Ammonia-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die 
11
0.0
1

TEXTBOX
34
1084
627
1154
if Ammonia > Ammonia2 and Ammonia <= Ammonia3 and Ammonia-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

TEXTBOX
33
1181
641
1251
if Ammonia > Ammonia2 and Ammonia <= Ammonia3 and Ammonia-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

TEXTBOX
35
1275
625
1345
if Ammonia > Ammonia3 and Ammonia <= Ammonia4 and Ammonia-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

TEXTBOX
45
1404
649
1474
if Ammonia > Ammonia3 and Ammonia <= Ammonia4 and Ammonia-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

TEXTBOX
44
1510
635
1580
if Ammonia > Ammonia4 and Ammonia <= Ammonia5 and Ammonia-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

TEXTBOX
44
1622
652
1692
if Ammonia > Ammonia4 and Ammonia <= Ammonia5 and Ammonia-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

TEXTBOX
99
1740
482
1782
if Ammonia > Ammonia5 and Ammonia-duration < 12 and rand-num <= Ammonia6-probability then die
11
0.0
1

TEXTBOX
98
1853
506
1895
if Ammonia > Ammonia5 and Ammonia-duration >= 12 and rand-num <= Ammonia6-probabilityb then die
11
0.0
1

SLIDER
110
718
282
751
Ammonia1
Ammonia1
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
319
718
406
778
Ammonia1-probability
0
1
0
Number

INPUTBOX
317
812
409
872
Ammonia1-probabilityb
0
1
0
Number

SLIDER
108
919
280
952
Ammonia2
Ammonia2
0
15
10
1
1
NIL
HORIZONTAL

INPUTBOX
320
918
405
978
Ammonia2-probability
0
1
0
Number

INPUTBOX
318
1013
409
1073
Ammonia2-probabilityb
0
1
0
Number

INPUTBOX
322
1106
408
1166
Ammonia3-probability
0
1
0
Number

SLIDER
108
1113
280
1146
Ammonia3
Ammonia3
0
25
20
1
1
NIL
HORIZONTAL

INPUTBOX
320
1204
413
1264
Ammonia3-probabilityb
0
1
0
Number

SLIDER
108
1305
280
1338
Ammonia4
Ammonia4
0
30
25
1
1
NIL
HORIZONTAL

INPUTBOX
325
1297
412
1357
Ammonia4-probability
0
1
0
Number

INPUTBOX
325
1434
418
1494
Ammonia4-probabilityb
0
1
0
Number

INPUTBOX
330
1541
417
1601
Ammonia5-probability
0
1
0
Number

SLIDER
108
1538
280
1571
Ammonia5
Ammonia5
0
40
30
1
1
NIL
HORIZONTAL

INPUTBOX
329
1653
422
1713
Ammonia5-probabilityb
0
1
0
Number

INPUTBOX
333
1771
420
1831
Ammonia6-probability
0
1
0
Number

INPUTBOX
332
1880
425
1940
Ammonia6-probabilityb
0
1
0
Number

TEXTBOX
743
691
1273
761
if Temp < Temp1 and Temp-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
743
793
1289
863
if Temp < Temp1 and Temp-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

TEXTBOX
744
886
1399
956
if Temp >= Temp1 and Temp <= Temp2 and Temp-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

TEXTBOX
743
981
1407
1051
if Temp >= Temp1 and Temp <= Temp2 and Temp-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

TEXTBOX
743
1065
1384
1135
if Temp > Temp2 and Temp <= Temp3 and Temp-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

TEXTBOX
746
1141
1401
1211
if Temp > Temp2 and Temp <= Temp3 and Temp-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

TEXTBOX
745
1220
1387
1290
if Temp > Temp3 and Temp <= Temp4 and Temp-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

TEXTBOX
744
1300
1406
1370
if Temp > Temp3 and Temp <= Temp4 and Temp-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

TEXTBOX
745
1382
1389
1452
if Temp > Temp4 and Temp <= Temp5 and Temp-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

TEXTBOX
743
1470
1404
1540
if Temp > Temp4 and Temp <= Temp5 and Temp-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

TEXTBOX
747
1553
1356
1596
if Temp > Temp5 and Temp-duration < 12 and rand-num <= Temp6-probability then die
11
0.0
1

INPUTBOX
1079
716
1181
776
Temp1-probability
0
1
0
Number

SLIDER
815
721
987
754
Temp1
Temp1
0
10
4
1
1
NIL
HORIZONTAL

INPUTBOX
1078
818
1186
878
Temp1-probabilityb
0
1
0
Number

INPUTBOX
1081
910
1182
970
Temp2-probability
0
1
0
Number

SLIDER
816
912
988
945
Temp2
Temp2
0
10
8
1
1
NIL
HORIZONTAL

INPUTBOX
1079
1001
1184
1061
Temp2-probabilityb
0
1
0
Number

INPUTBOX
1083
1081
1184
1141
Temp3-probability
0
1
0
Number

SLIDER
821
1087
993
1120
Temp3
Temp3
0
15
10
1
1
NIL
HORIZONTAL

INPUTBOX
1083
1160
1188
1220
Temp3-probabilityb
0
1
0
Number

INPUTBOX
1085
1237
1185
1297
Temp4-probability
0
1
0
Number

SLIDER
822
1239
994
1272
Temp4
Temp4
0
25
20
1
1
NIL
HORIZONTAL

INPUTBOX
1084
1320
1189
1380
Temp4-probabilityb
0
1
0
Number

INPUTBOX
1085
1406
1188
1466
Temp5-probability
0
1
0
Number

SLIDER
821
1408
993
1441
Temp5
Temp5
0
40
32
1
1
NIL
HORIZONTAL

INPUTBOX
1084
1488
1189
1548
Temp5-probabilityb
0
1
0
Number

INPUTBOX
1088
1577
1187
1637
Temp6-probability
0
1
0
Number

TEXTBOX
1505
791
1883
861
if Salinity < Salinity1 and Salinity-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

TEXTBOX
1504
888
1902
958
if Salinity >= Salinity1 and Salinity <= Salinity2 and Salinity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

TEXTBOX
1508
979
1910
1049
if Salinity >= Salinity1 and Salinity <= Salinity2 and Salinity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

TEXTBOX
1508
1066
1897
1136
if Salinity > Salinity2 and Salinity <= Salinity3 and Salinity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

TEXTBOX
1509
1140
1891
1210
if Salinity > Salinity2 and Salinity <= Salinity3 and Salinity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

TEXTBOX
1509
1221
1880
1291
if Salinity > Salinity3 and Salinity <= Salinity4 and Salinity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

TEXTBOX
1509
1301
1885
1371
if Salinity > Salinity3 and Salinity <= Salinity4 and Salinity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

TEXTBOX
1498
1381
1920
1451
if Salinity > Salinity4 and Salinity <= Salinity5 and Salinity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

TEXTBOX
1499
1470
1915
1540
if Salinity > Salinity4 and Salinity <= Salinity5 and Salinity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

TEXTBOX
1497
1564
1871
1606
if Salinity > Salinity5 and Salinity-duration < 12 and rand-num <= Salinity6-probability then die
11
0.0
1

SLIDER
1527
729
1699
762
Salinity1
Salinity1
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
1529
922
1701
955
Salinity2
Salinity2
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
1532
1095
1704
1128
Salinity3
Salinity3
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
1535
1251
1707
1284
Salinity4
Salinity4
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
1537
1414
1709
1447
Salinity5
Salinity5
0
10
10
1
1
NIL
HORIZONTAL

INPUTBOX
1749
1585
1848
1645
Salinity6-probability
0
1
0
Number

INPUTBOX
1747
1501
1851
1561
Salinity5-probabilityb
0
1
0
Number

INPUTBOX
1743
1410
1850
1470
Salinity5-probability
0
1
0
Number

INPUTBOX
1739
1324
1853
1384
Salinity4-probabilityb
0
1
0
Number

INPUTBOX
1740
1246
1848
1306
Salinity4-probability
0
1
0
Number

INPUTBOX
1737
1164
1849
1224
Salinity3-probabilityb
0
1
0
Number

INPUTBOX
1739
1082
1846
1142
Salinity3-probability
0
1
0
Number

INPUTBOX
1740
1005
1854
1065
Salinity2-probabilityb
0
1
0
Number

INPUTBOX
1743
918
1850
978
Salinity2-probability
0
1
0
Number

INPUTBOX
1739
821
1854
881
Salinity1-probabilityb
0
1
0
Number

INPUTBOX
1741
718
1848
778
Salinity1-probability
0
1
0
Number

TEXTBOX
2040
690
2492
760
if Calcium < Calcium1 and Calcium-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
1502
689
1924
759
if Salinity < Salinity1 and Salinity-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
2039
788
2522
858
if Calcium < Calcium1 and Calcium-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

TEXTBOX
2028
888
2499
972
if Calcium >= Calcium1 and Calcium <= Calcium2 and Calcium-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

TEXTBOX
2029
975
2522
1059
if Calcium >= Calcium1 and Calcium <= Calcium2 and Calcium-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

TEXTBOX
2028
1066
2496
1150
if Calcium > Calcium2 and Calcium <= Calcium3 and Calcium-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

TEXTBOX
2028
1139
2500
1223
if Calcium > Calcium2 and Calcium <= Calcium3 and Calcium-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

TEXTBOX
2028
1220
2502
1304
if Calcium > Calcium3 and Calcium <= Calcium4 and Calcium-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

TEXTBOX
2025
1301
2481
1385
if Calcium > Calcium3 and Calcium <= Calcium4 and Calcium-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

TEXTBOX
2027
1378
2498
1462
if Calcium > Calcium4 and Calcium <= Calcium5 and Calcium-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

TEXTBOX
2025
1467
2509
1551
if Calcium > Calcium4 and Calcium <= Calcium5 and Calcium-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

TEXTBOX
2027
1565
2398
1607
if Calcium > Calcium5 and Calcium-duration < 12 and rand-num <= Calcium6-probability then die
11
0.0
1

SLIDER
2028
730
2200
763
Calcium1
Calcium1
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
2027
925
2199
958
Calcium2
Calcium2
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
2029
1096
2201
1129
Calcium3
Calcium3
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
2028
1252
2200
1285
Calcium4
Calcium4
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
2029
1410
2201
1443
Calcium5
Calcium5
0
10
10
1
1
NIL
HORIZONTAL

INPUTBOX
2278
1588
2389
1648
Calcium6-probability
0
1
0
Number

INPUTBOX
2276
1496
2393
1556
Calcium5-probabilityb
0
1
0
Number

INPUTBOX
2279
1400
2389
1460
Calcium5-probability
0
1
0
Number

INPUTBOX
2277
1318
2397
1378
Calcium4-probabilityb
0
1
0
Number

INPUTBOX
2279
1240
2390
1300
Calcium4-probability
0
1
0
Number

INPUTBOX
2278
1159
2396
1219
Calcium3-probabilityb
0
1
0
Number

INPUTBOX
2278
1079
2389
1139
Calcium3-probability
0
1
0
Number

INPUTBOX
2277
1004
2395
1064
Calcium2-probabilityb
0
1
0
Number

INPUTBOX
2276
910
2389
970
Calcium2-probability
0
1
0
Number

INPUTBOX
2276
814
2394
874
Calcium1-probabilityb
0
1
0
Number

INPUTBOX
2275
715
2386
775
Calcium1-probability
0
1
0
Number

TEXTBOX
123
644
372
684
Ammonia Threshold for Mortality
16
13.0
1

TEXTBOX
832
651
1104
711
Temperature Threshold for Mortality
16
13.0
1

TEXTBOX
1587
653
1817
693
Salinity Threshold for Mortality
16
13.0
1

TEXTBOX
2156
652
2389
692
Calcium Threshold for Mortality
16
13.0
1

TEXTBOX
1246
2013
1479
2053
Hardness Threshold for Mortality
16
13.0
1

TEXTBOX
682
2011
956
2071
Conductivity Threshold for Mortality
16
13.0
1

TEXTBOX
72
2010
428
2070
Dissolved Oxygen (DO) Threshold for Mortality
16
13.0
1

TEXTBOX
1861
2018
2183
2078
Chlorophyll A (chl-a) Threshold for Mortality
16
13.0
1

TEXTBOX
2426
2018
2713
2078
Potassium (K) Threshold for Mortality
16
13.0
1

TEXTBOX
2730
654
2948
694
pH Threshold for Mortality
16
13.0
1

TEXTBOX
2957
2018
3327
2078
Current-Velocity-Turbulence Threshold for Mortality
16
13.0
1

TEXTBOX
2667
690
3009
746
if pH < pH1 and pH-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
2666
787
3013
843
if pH < pH1 and pH-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

TEXTBOX
2665
887
3146
957
if pH >= pH1 and pH <= pH2 and pH-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

TEXTBOX
2665
974
3141
1044
if pH >= pH1 and pH <= pH2 and pH-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

TEXTBOX
2664
1066
3122
1136
if pH > pH2 and pH <= pH3 and pH-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

TEXTBOX
2665
1139
3155
1209
if pH > pH2 and pH <= pH3 and pH-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

TEXTBOX
2667
1218
3127
1288
if pH > pH3 and pH <= pH4 and pH-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

TEXTBOX
2667
1297
3135
1367
if pH > pH3 and pH <= pH4 and pH-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

TEXTBOX
2667
1379
3142
1449
if pH > pH4 and pH <= pH5 and pH-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

TEXTBOX
2670
1465
3117
1535
if pH > pH4 and pH <= pH5 and pH-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

TEXTBOX
2669
1570
3035
1612
if pH > pH5 and pH-duration < 12 and rand-num <= pH6-probability then die
11
0.0
1

SLIDER
2670
1412
2842
1445
pH5
pH5
0
10
7
1
1
NIL
HORIZONTAL

INPUTBOX
2914
1399
3027
1459
pH5-probability
0
1
0
Number

INPUTBOX
2914
1496
3033
1556
pH5-probabilityb
0
1
0
Number

INPUTBOX
2916
1598
3028
1658
pH6-probability
0
1
0
Number

INPUTBOX
2914
1315
3032
1375
pH4-probabilityb
0
1
0
Number

INPUTBOX
2915
1235
3027
1295
pH4-probability
0
1
0
Number

SLIDER
2665
1250
2837
1283
pH4
pH4
0
10
7
1
1
NIL
HORIZONTAL

INPUTBOX
2925
1157
3015
1217
pH3-probabilityb
0
1
0
Number

INPUTBOX
2927
1079
3014
1139
pH3-probability
0
1
0
Number

SLIDER
2663
1097
2835
1130
pH3
pH3
0
10
7
1
1
NIL
HORIZONTAL

INPUTBOX
2924
999
3019
1059
pH2-probabilityb
0
1
0
Number

INPUTBOX
2928
908
3015
968
pH2-probability
0
1
0
Number

SLIDER
2665
920
2837
953
pH2
pH2
0
10
7
1
1
NIL
HORIZONTAL

INPUTBOX
2930
821
3021
881
pH1-probabilityb
0
1
0
Number

INPUTBOX
2929
721
3015
781
pH1-probability
0
1
0
Number

SLIDER
2664
732
2836
765
pH1
pH1
0
10
7
1
1
NIL
HORIZONTAL

TEXTBOX
39
2061
451
2117
if DO < DO1 and DO-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
41
2153
440
2209
if DO < DO1 and DO-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

INPUTBOX
270
2085
357
2145
DO1-probability
0
1
0
Number

SLIDER
38
2100
210
2133
DO1
DO1
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
268
2190
363
2250
DO1-probabilityb
0
1
0
Number

TEXTBOX
37
2256
445
2326
if DO >= DO1 and DO <= DO2 and DO-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

SLIDER
38
2292
210
2325
DO2
DO2
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
272
2280
359
2340
DO2-probability
0
1
0
Number

TEXTBOX
39
2345
453
2415
if DO >= DO1 and DO <= DO2 and DO-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

INPUTBOX
271
2364
365
2424
DO2-probabilityb
0
1
0
Number

TEXTBOX
40
2430
475
2500
if DO > DO2 and DO <= DO3 and DO-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

SLIDER
39
2465
211
2498
DO3
DO3
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
278
2447
366
2507
DO3-probability
0
1
0
Number

TEXTBOX
40
2509
448
2579
if DO > DO2 and DO <= DO3 and DO-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

INPUTBOX
280
2528
371
2588
DO3-probabilityb
0
1
0
Number

TEXTBOX
40
2587
508
2657
if DO > DO3 and DO <= DO4 and DO-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

SLIDER
41
2619
213
2652
DO4
DO4
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
286
2607
371
2667
DO4-probability
0
1
0
Number

TEXTBOX
43
2668
474
2738
if DO > DO3 and DO <= DO4 and DO-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

INPUTBOX
282
2685
374
2745
DO4-probabilityb
0
1
0
Number

TEXTBOX
46
2748
487
2818
if DO > DO4 and DO <= DO5 and DO-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
286
2767
372
2827
DO5-probability
0
1
0
Number

SLIDER
45
2781
217
2814
DO5
DO5
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
46
2828
469
2898
if DO > DO4 and DO <= DO5 and DO-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

INPUTBOX
282
2850
374
2910
DO5-probabilityb
0
1
0
Number

TEXTBOX
50
2927
391
2969
if DO > DO5 and DO-duration < 12 and rand-num <= DO6-probability then die
11
0.0
1

INPUTBOX
290
2944
375
3004
DO6-probability
0
1
0
Number

TEXTBOX
606
2061
1019
2117
if Conductivity < Conductivity1 and Conductivity-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

TEXTBOX
606
2151
1086
2207
if Conductivity < Conductivity1 and Conductivity-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

TEXTBOX
607
2253
1094
2323
if Conductivity >= Conductivity1 and Conductivity <= Conductivity2 and Conductivity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

TEXTBOX
605
2345
1093
2415
if Conductivity >= Conductivity1 and Conductivity <= Conductivity2 and Conductivity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

TEXTBOX
613
2430
1093
2500
if Conductivity > Conductivity2 and Conductivity <= Conductivity3 and Conductivity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

TEXTBOX
614
2508
1070
2578
if Conductivity > Conductivity2 and Conductivity <= Conductivity3 and Conductivity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

TEXTBOX
616
2586
1087
2656
if Conductivity > Conductivity3 and Conductivity <= Conductivity4 and Conductivity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

TEXTBOX
617
2666
1098
2736
if Conductivity > Conductivity3 and Conductivity <= Conductivity4 and Conductivity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

TEXTBOX
618
2752
1092
2822
if Conductivity > Conductivity4 and Conductivity <= Conductivity5 and Conductivity-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

TEXTBOX
617
2842
1130
2912
if Conductivity > Conductivity4 and Conductivity <= Conductivity5 and Conductivity-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

TEXTBOX
623
2940
1038
2982
if Conductivity > Conductivity5 and Conductivity-duration < 12 and rand-num <= Conductivity6-probability then die
11
0.0
1

INPUTBOX
903
2957
1033
3017
Conductivity6-probability
0
1
0
Number

INPUTBOX
897
2872
1032
2932
Conductivity5-probabilityb
0
1
0
Number

INPUTBOX
895
2780
1027
2840
Conductivity5-probability
0
1
0
Number

SLIDER
622
2797
794
2830
Conductivity5
Conductivity5
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
894
2692
1029
2752
Conductivity4-probabilityb
0
1
0
Number

INPUTBOX
897
2610
1026
2670
Conductivity4-probability
0
1
0
Number

SLIDER
616
2617
788
2650
Conductivity4
Conductivity4
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
894
2531
1030
2591
Conductivity3-probabilityb
0
1
0
Number

SLIDER
613
2463
785
2496
Conductivity3
Conductivity3
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
895
2457
1026
2517
Conductivity3-probability
0
1
0
Number

INPUTBOX
894
2370
1031
2430
Conductivity2-probabilityb
0
1
0
Number

INPUTBOX
894
2284
1025
2344
Conductivity2-probability
0
1
0
Number

SLIDER
606
2285
778
2318
Conductivity2
Conductivity2
0
10
5
1
1
NIL
HORIZONTAL

INPUTBOX
886
2177
1023
2237
Conductivity1-probabilityb
0
1
0
Number

INPUTBOX
886
2084
1017
2144
Conductivity1-probability
0
1
0
Number

SLIDER
606
2093
778
2126
Conductivity1
Conductivity1
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1180
2061
1606
2131
if Hardness < Hardness1 and Hardness-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

INPUTBOX
1477
2080
1592
2140
Hardness1-probability
0
1
0
Number

SLIDER
1179
2094
1351
2127
Hardness1
Hardness1
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1180
2148
1617
2218
if Hardness < Hardness1 and Hardness-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

INPUTBOX
1477
2173
1596
2233
Hardness1-probabilityb
0
1
0
Number

TEXTBOX
1181
2252
1690
2350
if Hardness >= Hardness1 and Hardness <= Hardness2 and Hardness-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

INPUTBOX
1480
2275
1595
2335
Hardness2-probability
0
1
0
Number

SLIDER
1182
2288
1354
2321
Hardness2
Hardness2
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1182
2342
1680
2440
if Hardness >= Hardness1 and Hardness <= Hardness2 and Hardness-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

INPUTBOX
1480
2368
1599
2428
Hardness2-probabilityb
0
1
0
Number

TEXTBOX
1188
2430
1675
2528
if Hardness > Hardness2 and Hardness <= Hardness3 and Hardness-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

INPUTBOX
1482
2447
1595
2507
Hardness3-probability
0
1
0
Number

SLIDER
1185
2462
1357
2495
Hardness3
Hardness3
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1186
2508
1660
2606
if Hardness > Hardness2 and Hardness <= Hardness3 and Hardness-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

INPUTBOX
1481
2527
1602
2587
Hardness3-probabilityb
0
1
0
Number

TEXTBOX
1191
2593
1645
2710
if Hardness > Hardness3 and Hardness <= Hardness4 and Hardness-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

INPUTBOX
1484
2609
1597
2669
Hardness4-probability
0
1
0
Number

SLIDER
1191
2624
1363
2657
Hardness4
Hardness4
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1193
2669
1701
2767
if Hardness > Hardness3 and Hardness <= Hardness4 and Hardness-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

INPUTBOX
1511
2682
1631
2742
Hardness4-probabilityb
0
1
0
Number

TEXTBOX
1194
2745
1704
2843
if Hardness > Hardness4 and Hardness <= Hardness5 and Hardness-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
1512
2762
1625
2822
Hardness5-probability
0
1
0
Number

SLIDER
1194
2775
1366
2808
Hardness5
Hardness5
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1194
2841
1722
2939
if Hardness > Hardness4 and Hardness <= Hardness5 and Hardness-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability5b then die
11
0.0
1

INPUTBOX
1512
2861
1631
2921
Hardness5-probabilityb
0
1
0
Number

TEXTBOX
1197
2934
1618
2976
if Hardness > Hardness5 and Hardness-duration < 12 and rand-num <= Hardness6-probability then die
11
0.0
1

INPUTBOX
1517
2950
1632
3010
Hardness6-probability
0
1
0
Number

TEXTBOX
1787
2061
2254
2131
if chl-a < chl-a1 and chl-a-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

INPUTBOX
2087
2082
2242
2142
chl-a1-probability
0
1
0
Number

SLIDER
1787
2093
1959
2126
chl-a1
chl-a1
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1788
2145
2248
2215
if chl-a < chl-a1 and chl-a-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

INPUTBOX
2106
2168
2208
2228
chl-a1-probabilityb
0
1
0
Number

TEXTBOX
1789
2241
2227
2311
if chl-a >= chl-a1 and chl-a <= chl-a2 and chl-a-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

INPUTBOX
2111
2260
2208
2320
chl-a2-probability
0
1
0
Number

SLIDER
1789
2271
1961
2304
chl-a2
chl-a2
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1789
2342
2230
2412
if chl-a >= chl-a1 and chl-a <= chl-a2 and chl-a-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

INPUTBOX
2109
2360
2211
2420
chl-a2-probabilityb
0
1
0
Number

TEXTBOX
1788
2428
2213
2498
if chl-a > chl-a2 and chl-a <= chl-a3 and chl-a-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

INPUTBOX
2116
2450
2213
2510
chl-a3-probability
0
1
0
Number

SLIDER
1789
2459
1961
2492
chl-a3
chl-a3
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1788
2511
2225
2581
if chl-a > chl-a2 and chl-a <= chl-a3 and chl-a-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

INPUTBOX
2115
2530
2216
2590
chl-a3-probabilityb
0
1
0
Number

TEXTBOX
1787
2591
2219
2661
if chl-a > chl-a3 and chl-a <= chl-a4 and chl-a-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

INPUTBOX
2121
2609
2220
2669
chl-a4-probability
0
1
0
Number

SLIDER
1789
2623
1961
2656
chl-a4
chl-a4
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1791
2670
2232
2740
if chl-a > chl-a3 and chl-a <= chl-a4 and chl-a-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

INPUTBOX
2119
2687
2223
2747
chl-a4-probabilityb
0
1
0
Number

TEXTBOX
1789
2746
2213
2816
if chl-a > chl-a4 and chl-a <= chl-a5 and chl-a-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
2123
2762
2220
2822
chl-a5-probability
0
1
0
Number

SLIDER
1793
2777
1965
2810
chl-a5
chl-a5
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
1792
2840
2210
2910
if chl-a > chl-a4 and chl-a <= chl-a5 and chl-a-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
2123
2860
2224
2920
chl-a5-probabilityb
0
1
0
Number

TEXTBOX
1790
2927
2194
2970
if chl-a > chl-a5 and chl-a-duration < 12 and rand-num <= chl-a6-probability then die
11
0.0
1

INPUTBOX
2123
2947
2220
3007
chl-a6-probability
0
1
0
Number

TEXTBOX
2367
2062
2793
2132
if K < K1 and K-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

INPUTBOX
2685
2080
2767
2140
K1-probability
0
1
0
Number

SLIDER
2367
2094
2539
2127
K1
K1
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
2366
2145
2776
2201
if K < K1 and K-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

INPUTBOX
2685
2168
2769
2228
K1-probabilityb
0
1
0
Number

TEXTBOX
2367
2240
2723
2296
if K >= K1 and K <= K2 and K-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

INPUTBOX
2686
2261
2771
2321
K2-probability
0
1
0
Number

SLIDER
2369
2271
2541
2304
K2
K2
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
2370
2341
2838
2411
if K >= K1 and K <= K2 and K-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

INPUTBOX
2687
2360
2774
2420
K2-probabilityb
0
1
0
Number

TEXTBOX
2370
2425
2818
2481
if K > K2 and K <= K3 and K-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

INPUTBOX
2691
2444
2771
2504
K3-probability
0
1
0
Number

SLIDER
2373
2456
2545
2489
K3
K3
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
2371
2506
2829
2576
if K > K2 and K <= K3 and K-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

INPUTBOX
2690
2523
2776
2583
K3-probabilityb
0
1
0
Number

TEXTBOX
2374
2589
2814
2645
if K > K3 and K <= K4 and K-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

INPUTBOX
2693
2609
2775
2669
K4-probability
0
1
0
Number

SLIDER
2377
2619
2549
2652
K4
K4
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
2371
2668
2825
2738
if K > K3 and K <= K4 and K-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

INPUTBOX
2691
2686
2777
2746
K4-probabilityb
0
1
0
Number

TEXTBOX
2373
2745
2830
2801
if K > K4 and K <= K5 and K-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
2694
2764
2776
2824
K5-probability
0
1
0
Number

SLIDER
2375
2776
2547
2809
K5
K5
0
10
5
1
1
NIL
HORIZONTAL

TEXTBOX
2374
2839
2823
2895
if K > K4 and K <= K5 and K-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
2691
2859
2778
2919
K5-probabilityb
0
1
0
Number

TEXTBOX
2377
2928
2782
2971
if K > K5 and K-duration < 12 and rand-num <= K6-probability then die
11
0.0
1

INPUTBOX
2694
2949
2772
3009
K6-probability
0
1
0
Number

TEXTBOX
2919
2062
3531
2146
if Velocity-Turbulence < Velocity-Turbulence1 and Velocity-Turbulence-duration < 7 and age >= 0 and age < 100 and rand-num <= probability1 then die 
11
0.0
1

SLIDER
2922
2096
3094
2129
Velocity-Turbulence1
Velocity-Turbulence1
0
100
50
1
1
NIL
HORIZONTAL

INPUTBOX
3255
2083
3427
2143
Velocity-Turbulence1-probability
0
1
0
Number

TEXTBOX
2918
2141
3564
2225
if Velocity-Turbulence < Velocity-Turbulence1 and Velocity-Turbulence-duration >= 7 and age >= 0 and age < 100 and rand-num <= probability1b then die
11
0.0
1

INPUTBOX
3257
2161
3432
2221
Velocity-Turbulence1-probabilityb
0
1
0
Number

TEXTBOX
2919
2223
3614
2335
if Velocity-Turbulence >= Velocity-Turbulence1 and Velocity-Turbulence <= Velocity-Turbulence2 and Velocity-Turbulence-duration < 12 and age >= 0 and age < 100 and rand-num <= probability2 then die 
11
0.0
1

INPUTBOX
3262
2243
3435
2303
Velocity-Turbulence2-probability
0
1
0
Number

SLIDER
2925
2255
3097
2288
Velocity-Turbulence2
Velocity-Turbulence2
0
100
50
1
1
NIL
HORIZONTAL

TEXTBOX
2919
2333
3563
2445
if Velocity-Turbulence >= Velocity-Turbulence1 and Velocity-Turbulence <= Velocity-Turbulence2 and Velocity-Turbulence-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability2b then die
11
0.0
1

INPUTBOX
3265
2364
3439
2424
Velocity-Turbulence2-probabilityb
0
1
0
Number

TEXTBOX
2922
2425
3554
2537
if Velocity-Turbulence > Velocity-Turbulence2 and Velocity-Turbulence <= Velocity-Turbulence3 and Velocity-Turbulence-duration < 12 and age >= 0 and age < 100 and rand-num <= probability3 then die
11
0.0
1

INPUTBOX
3272
2448
3441
2508
Velocity-Turbulence3-probability
0
1
0
Number

SLIDER
2924
2456
3096
2489
Velocity-Turbulence3
Velocity-Turbulence3
0
100
50
1
1
NIL
HORIZONTAL

TEXTBOX
2923
2508
3563
2620
if Velocity-Turbulence > Velocity-Turbulence2 and Velocity-Turbulence <= Velocity-Turbulence3 and Velocity-Turbulence-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability3b then die
11
0.0
1

INPUTBOX
3277
2530
3455
2590
Velocity-Turbulence3-probabilityb
0
1
0
Number

TEXTBOX
2924
2593
3528
2705
if Velocity-Turbulence > Velocity-Turbulence3 and Velocity-Turbulence <= Velocity-Turbulence4 and Velocity-Turbulence-duration < 12 and age >= 0 and age < 100 and rand-num <= probability4 then die
11
0.0
1

INPUTBOX
3283
2622
3455
2682
Velocity-Turbulence4-probability
0
1
0
Number

SLIDER
2928
2622
3100
2655
Velocity-Turbulence4
Velocity-Turbulence4
0
100
50
1
1
NIL
HORIZONTAL

TEXTBOX
2912
2682
3540
2794
if Velocity-Turbulence > Velocity-Turbulence3 and Velocity-Turbulence <= Velocity-Turbulence4 and Velocity-Turbulence-duration >= 12 and age >= 0 and age < 100 and rand-num <= probability4b then die
11
0.0
1

INPUTBOX
3289
2700
3465
2760
Velocity-Turbulence4-probabilityb
0
1
0
Number

TEXTBOX
2930
2761
3651
2873
if Velocity-Turbulence > Velocity-Turbulence4 and Velocity-Turbulence <= Velocity-Turbulence5 and Velocity-Turbulence-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
3289
2778
3465
2838
Velocity-Turbulence5-probability
0
1
0
Number

SLIDER
2937
2790
3109
2823
Velocity-Turbulence5
Velocity-Turbulence5
0
100
50
1
1
NIL
HORIZONTAL

TEXTBOX
2934
2838
3516
2950
if Velocity-Turbulence > Velocity-Turbulence4 and Velocity-Turbulence <= Velocity-Turbulence5 and Velocity-Turbulence-duration < 12 and age >= 0 and age < 100 and rand-num <= probability5 then die
11
0.0
1

INPUTBOX
3291
2871
3470
2931
Velocity-Turbulence5-probabilityb
0
1
0
Number

TEXTBOX
2935
2930
3473
2987
if Velocity-Turbulence > Velocity-Turbulence5 and Velocity-Turbulence-duration < 12 and rand-num <= Velocity-Turbulence6-probability then die
11
0.0
1

INPUTBOX
3303
2955
3458
3015
Velocity-Turbulence6-probability
0
1
0
Number

TEXTBOX
747
1643
1234
1698
if Temp > Temp5 and Temp-duration >= 12 and rand-num <= Temp6-probabilityb then die
11
0.0
1

INPUTBOX
1090
1670
1192
1730
Temp6-probabilityb
0
1
0
Number

TEXTBOX
1497
1650
1975
1705
if Salinity > Salinity5 and Salinity-duration >= 12 and rand-num <= Salinity6-probabilityb then die
11
0.0
1

INPUTBOX
1749
1674
1853
1734
Salinity6-probabilityb
0
1
0
Number

TEXTBOX
2027
1650
2509
1705
if Calcium > Calcium5 and Calcium-duration >= 12 and rand-num <= Calcium6-probabilityb then die
11
0.0
1

INPUTBOX
2279
1669
2394
1729
Calcium6-probabilityb
0
1
0
Number

TEXTBOX
2669
1665
3148
1707
if pH > pH5 and pH-duration >= 12 and rand-num <= pH6-probabilityb then die
11
0.0
1

INPUTBOX
2933
1683
3021
1743
pH6-probabilityb
0
1
0
Number

TEXTBOX
45
3015
450
3057
if DO > DO5 and DO-duration >= 12 and rand-num <= DO6-probabilityb then die
11
0.0
1

INPUTBOX
289
3038
376
3098
DO6-probabilityb
0
1
0
Number

TEXTBOX
623
3019
1001
3074
if Conductivity > Conductivity5 and Conductivity-duration >= 12 and rand-num <= Conductivity6-probabilityb then die
11
0.0
1

INPUTBOX
905
3039
1033
3099
Conductivity6-probabilityb
0
1
0
Number

TEXTBOX
1198
3015
1622
3070
if Hardness > Hardness5 and Hardness-duration >= 12 and rand-num <= Hardness6-probabilityb then die
11
0.0
1

INPUTBOX
1515
3038
1633
3098
Hardness6-probabilityb
0
1
0
Number

TEXTBOX
1792
3009
2251
3051
if chl-a > chl-a5 and chl-a-duration >= 12 and rand-num <= chl-a6-probabilityb then die
11
0.0
1

INPUTBOX
2125
3033
2222
3093
chl-a6-probabilityb
0
1
0
Number

TEXTBOX
2374
3009
2846
3051
if K > K5 and K-duration >= 12 and rand-num <= K6-probabilityb then die
11
0.0
1

INPUTBOX
2693
3027
2775
3087
K6-probabilityb
0
1
0
Number

TEXTBOX
2939
3015
3511
3098
if Velocity-Turbulence > Velocity-Turbulence5 and Velocity-Turbulence-duration >= 12 and rand-num <=Velocity-Turbulence6-probabilityb then die
11
0.0
1

INPUTBOX
3303
3032
3463
3092
Velocity-Turbulence6-probabilityb
0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
3
Polygon -6459832 true true 75 165 60 135 75 105 120 135 120 165 105 195
Line -16777216 false 60 135 90 165
Polygon -6459832 true true 60 135 105 165 105 195 90 165
Line -16777216 false 90 165 105 195
Line -16777216 false 75 150 90 165
Line -16777216 false 60 135 90 165

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

zebra mussel
false
3
Polygon -6459832 true true 75 165 60 135 75 105 120 135 120 165 105 195
Line -16777216 false 75 105 90 165
Polygon -6459832 true true 60 135 105 165 105 195 90 165
Line -16777216 false 90 165 105 195
Polygon -6459832 false true 75 105 60 135 90 165
Polygon -16777216 true false 75 135 90 165 75 135 75 105 90 165
Line -16777216 false 75 105 90 165
Polygon -6459832 true true 150 120 135 90 150 60 195 90 195 120 180 150
Line -16777216 false 150 60 165 120
Line -16777216 false 165 120 180 150
Polygon -16777216 true false 150 90 165 120 150 90 150 60 165 120
Polygon -6459832 true true 165 240 150 210 165 180 210 210 210 240 195 270
Line -16777216 false 165 180 180 240
Line -16777216 false 180 240 195 270
Polygon -16777216 true false 165 210 180 240 165 210 165 180 180 240
Polygon -6459832 true true 75 270 60 255 45 225 75 240 90 270 75 270
Polygon -16777216 true false 60 240 75 270 60 240 45 225 75 270
Polygon -6459832 true true 135 285 120 270 105 240 135 255 150 285 135 285
Polygon -16777216 true false 120 255 135 285 120 255 105 240 135 285

zebra mussel 2
false
3
Polygon -6459832 true true 75 165 60 135 75 105 120 135 120 165 105 195
Line -16777216 false 75 105 90 165
Polygon -6459832 true true 60 135 105 165 105 195 90 165
Line -16777216 false 90 165 105 195
Polygon -6459832 false true 75 105 60 135 90 165
Polygon -16777216 true false 75 135 90 165 75 135 75 105 90 165
Line -16777216 false 75 105 90 165
Polygon -6459832 true true 165 240 150 210 165 180 210 210 210 240 195 270
Line -16777216 false 165 180 180 240
Line -16777216 false 180 240 195 270
Polygon -16777216 true false 165 210 180 240 165 210 165 180 180 240
Polygon -6459832 true true 135 285 120 270 105 240 135 255 150 285 135 285
Polygon -16777216 true false 120 255 135 285 120 255 105 240 135 285

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
