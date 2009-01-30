function err = ErrFun(var,z1,z2)

z = var(1)+i*var(2);
theta = var(3);

z1 = z+exp(i*theta)*z1;

err = sum(abs(z1-z2).^2);

