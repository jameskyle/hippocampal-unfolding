function result = value(n1,n2,hue)

if(isempty(hue))
    result = [];
    return;
end

result = n1;

index = find(hue > 360);
hue(index) = hue(index) - 360;
index = find(hue < 0);
hue(index) = hue(index) + 360;
index = find(hue < 60);
result(index) = n1(index) + (n2(index)-n1(index)) .* hue(index) / 60;
index = find((hue < 180) & (hue >= 60));
result(index) = n2(index);
index = find((hue < 240) & (hue >= 180));
result(index) = n1(index) + (n2(index)-n1(index)) .* (240-hue(index)) / 60;
