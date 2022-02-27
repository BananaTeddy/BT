function ShorgenNumberString(int)
    local counter = 0
    while int > 1000 do
        int = int / 1000
        counter = counter + 1
        print(counter)
    end

    local t = {
        [0] = '%i',
        [1] = '%.2fK',
        [2] = '%.2fM',
        [3] = '%.2fG'
    }

    return string.format(t[counter], int)
end



local s = ShorgenNumberString(4672123654)
print('Shortened value: ' .. s)