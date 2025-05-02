-- discrete_slider.lua

local discrete_slider = {}

-- Набор дискретных множителей (можно переопределить если нужно)
discrete_slider.multipliers = {1/10, 1/5, 1/3, 1/2, 1, 2, 3, 5, 10} 
discrete_slider.slidersVal = {0}
for exp = 0, 3 do
    for digit = 1,9 do
        table.insert(discrete_slider.slidersVal, digit * 10^exp)
    end
end
table.insert(discrete_slider.slidersVal,10000)
-- Возвращает ближайший индекс множителя к target_value
local function get_nearest_offset(target_value)
    local best_key = 1
    local best_diff = math.huge
    for key, value in ipairs(discrete_slider.slidersVal) do
        local diff = math.abs(value - target_value)
        if diff < best_diff then
            best_diff = diff
            best_key = key
        end
    end
    return best_key
end

-- Вычисляет min/max индексы для слайдера по stack_size
function discrete_slider.get_slider_min_max(stack_size)
    assert(type(stack_size) == "number", "stack_size must be a number")
    local min_required_count = 1  -- Минимум 1 предмет
    local min_multiplier = min_required_count / stack_size
    local offset = get_nearest_offset(min_multiplier)
    return {min = offset, max = #discrete_slider.slidersVal}
end

-- Преобразует slider_value → item_count
function discrete_slider.slider_value_to_count(slider_value, stack_size)
    assert(type(slider_value) == "number", "slider_value must be a number")
    return math.ceil(discrete_slider.slidersVal[slider_value])
end

-- Преобразует item_count → slider_value
function discrete_slider.count_to_slider_value(item_count, stack_size)
    assert(type(item_count) == "number", "item_count must be a number")
    return get_nearest_offset(item_count)
end


return discrete_slider