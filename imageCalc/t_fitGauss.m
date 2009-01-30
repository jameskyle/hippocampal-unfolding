function result = t_fitGauss(k,dpi,vd,f,v)


f = f + 1;
va = atan(1/vd)*180/pi;
N = round(dpi/va);


x1 = k(1)*gauss(k(2),N);
x2 = (v(1)-k(1))*gauss(k(3),N);
x = x1 + x2;

y = abs(fft(x,N));
z = y(f);
e = z - v;


result = sum(abs(e.*e));
