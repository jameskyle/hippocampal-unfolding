function result = t_fitGauss2(k,N,f,v)


f = f + 1;

x1 = k(1)*gauss(k(2),N);
x2 = (v(1)-k(1))*gauss(k(3),N);
x = x1 + x2;

y = abs(fft(x,N));
z = y(f);
e = z - v;


result = sum(abs(e.*e));
