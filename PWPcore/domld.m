load mld.dat
mt=[0:24]/2;
si=[45:69];
mld(:,2)=-mld(:,2);
load diff1.mat
mmld1=-zmld(:,si);
load diff3.mat
mmld3=-zmld(:,si);
load diff5.mat
mmld5=-zmld(:,si);
h=plot(mld(:,1),mld(:,2),'r'); hold on
set(h,'LineWidth',4);
xlabel('Month'); ylabel('Mixed Layer Depth')
h=text(5,-200,'Levitus');set(h,'FontSize',18,'Color','red');
h=plot(mt,mmld1,'b',mt,mmld3,'g',mt,mmld5,'c');
set(h,'LineWidth',2); set(gca,'LineWidth',2,'FontSize',16);
h=text(5,-180,'Kz=1.5');set(h,'FontSize',18,'Color','blue');
h=text(5,-160,'Kz=1.0');set(h,'FontSize',18,'Color','green');
h=text(5,-140,'Kz=0.5');set(h,'FontSize',18,'Color','cyan');


hold off
