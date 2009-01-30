rsqrd = makeSyntheticImage([65 65],'rsqrd');
displayImage(rsqrd);

gaussian = makeSyntheticImage([65 65],'gaussian',[-4 4],[-4 4],2);
displayImage(gaussian);

disc=makeDisc([64 64], 16);
displayImage(disc);

fractal=makeFractal([64 64], 2);
displayImage(fractal);

gauss=makeGaussian([64 64]);
displayImage(gauss);

impulse=makeImpulse([64 64]);
displayImage(impulse);

rad=makeR([64 64]);
displayImage(rad);

ramp=makeRamp([64 64],pi/4);
displayImage(ramp);

sine=makeSine([64 64],16,0);
displayImage(sine);

square=makeSquare([64 64],8,0);
displayImage(square);

theta=makeTheta([64 64]);
displayImage(theta);

zone=makeZonePlate([64 64]);
displayImage(zone);

