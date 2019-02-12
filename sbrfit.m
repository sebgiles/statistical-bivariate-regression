
Test.y_sbr = sbr(Train.Dx,Train.Dy,Test.Dx,"Increasing");
plot(Test.Dx, Test.y_sbr);

pause
close