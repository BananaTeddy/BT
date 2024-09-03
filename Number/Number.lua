BananaCore.Number = {}

function BananaCore.Number.ToShortString(number)
    local counter = 0

    while number > 1e3 do
        number = number / 1e3
        counter = counter + 1

        if counter == 6 then
            break
        end
    end

    local formats = {
        [0] = '%i',
        [1] = '%.1fk', -- thousands
        [2] = '%.1fm', -- millions
        [3] = '%.1fb', -- billions
        [4] = '%.1ft', -- trillions
        [5] = '%.1fq', -- quadrillions
        [6] = '%.1fQ' -- quintillions
    }

    return string.format(formats[counter], number)
end

function BananaCore.Number.ToShortUnitString(number)
    local counter = 0

    while number > 1e3 do
        number = number / 1e3
        counter = counter + 1

        if counter == 6 then
            break
        end
    end

    local formats = {
        [0] = '%i',
        [1] = '%.1f Kilo',
        [2] = '%.1f Mega',
        [3] = '%.1f Giga',
        [4] = '%.1f Tera',
        [5] = '%.1f Peta',
        [6] = '%.1f Exa'
    }

    return string.format(formats[counter], number)
end