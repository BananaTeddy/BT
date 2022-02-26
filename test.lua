local direction  = 0

for i = 1, 100 do
    direction = (direction + 1 )% 2
    print(direction)
end