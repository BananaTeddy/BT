
function main()
    local temperature = 50
    print(temperature)
    temperature = temperature + 1
    print(temperature)
    incrementTemperature()
    print(temperature)
end

function incrementTemperature()
    temperature = temperature + 10
end

main()