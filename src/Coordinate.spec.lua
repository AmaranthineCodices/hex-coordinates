return function()
    local Coordinate = require(script.Parent.Coordinate)

    describe("new", function()
        it("should create coordinates", function()
            local coordinate = Coordinate.new(3, 2)
            expect(coordinate.Q).to.equal(3)
            expect(coordinate.R).to.equal(2)
        end)

        it("should throw if given invalid arguments", function()
            expect(function()
                Coordinate.new(0.5, 0)
            end).to.throw()

            expect(function()
                Coordinate.new(0, "")
            end).to.throw()
        end)
    end)

    describe("AsCube", function()
        it("should convert to cube coordinates", function()
            local coordinate = Coordinate.new(3, 2)
            local x, y, z = coordinate:AsCube()
            expect(x).to.equal(3)
            expect(y).to.equal(-5)
            expect(z).to.equal(2)
        end)
    end)
end