--[[
    Represents a hexagonal coordinate.
    Coordinates are stored in axial (q, r) form, but can be easily
    converted to cube (x, y, z) form.
]]

--[[
    Returns a boolean representing whether the value is an integer.
]]
local function isInteger(value)
    return typeof(value) == "number" and math.floor(value) == value
end

local Coordinate = {}
Coordinate.__index = Coordinate

Coordinate.Orientation = {
    FlatTop = 0,
    PointyTop = 1,
}

--[[
    Creates a new Coordinate from a given q and r.
    q (integer): The Q coordinate of the pair.
    r (integer): The R coordinate of the pair.
]]
function Coordinate.new(q, r)
    assert(isInteger(q), ("bad argument #1 to new: expected integer, got %q"):format(typeof(q)))
    assert(isInteger(r), ("bad argument #2 to new: expected integer, got %q"):format(typeof(q)))

    return setmetatable({
        Q = q,
        R = r,
    }, Coordinate)
end

--[[
    Returns the cube form of the coordinate as a tuple.
]]
function Coordinate:AsCube()
    local x = self.Q
    local y = -self.Q - self.R
    local z = self.R

    return x, y, z
end

function Coordinate:__add(other)
    return Coordinate.new(
        self.Q + other.Q,
        self.R + other.R
    )
end

function Coordinate:__sub(other)
    return Coordinate.new(
        self.Q - other.Q,
        self.R - other.R
    )
end

function Coordinate:__unm()
    return Coordinate.new(
        -self.Q,
        -self.R
    )
end

--[[
    Returns an iterator over the hex's six neighbors.
]]
function Coordinate:Neighbors()
    return coroutine.wrap(function()
        for _, offset in ipairs(NEIGHBOR_OFFSETS) do
            coroutine.yield(self + offset)
        end
    end)
end

--[[
    Gets all the neighbors of the hex as an array.
]]
function Coordinate:GetNeighbors()
    local neighbors = {}

    for _, offset in ipairs(NEIGHBOR_OFFSETS) do
        table.insert(neighbors, self + offset)
    end

    return neighbors
end

--[[
    Gets the distance between this coordinate and another coordinate.
]]
function Coordinate:Distance(other)
    local selfX, selfY, selfZ = self:AsCube()
    local otherX, otherY, otherZ = other:AsCube()

    return math.max(
        math.abs(selfX - otherX),
        math.abs(selfY - otherY),
        math.abs(selfZ - otherZ)
    )
end

--[[
    Converts the coordinate's position to 2D coordinates centered at the origin.
    Multiply the return values of this function by your hex size and add scaling as desired.
]]
function Coordinate:ToWorldPosition(orientation)
    assert(Coordinate.Orientation[orientation] ~= nil, "bad argument #1 to ToWorldPosition: expected an Orientation")

    local x = self.Q * 3 / 2
    local y = (self.R + self.Q / 2) * math.sqrt(3)
    
    if orientation == Coordinate.Orientation.PointyTop then
        x, y = y, x
    end

    return x, y
end

-- Offsets used for calculating axial neighbors.
-- Declared here for scoping reasons.
local NEIGHBOR_OFFSETS = {
    Coordinate.new(-1,  0),
    Coordinate.new( 1,  0),
    Coordinate.new(-1,  1),
    Coordinate.new( 1, -1),
    Coordinate.new( 0,  1),
    Coordinate.new( 0, -1),
}

return Coordinate
