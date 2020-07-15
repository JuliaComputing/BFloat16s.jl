using Test, BFloat16s, Printf

@testset "comparisons" begin
	@test BFloat16(1)   <  BFloat16(2)
	@test BFloat16(1f0) <  BFloat16(2f0)
	@test BFloat16(1.0) <  BFloat16(2.0)
	@test BFloat16(1)   <= BFloat16(2)
	@test BFloat16(1f0) <= BFloat16(2f0)
	@test BFloat16(1.0) <= BFloat16(2.0)
	@test BFloat16(2)   >  BFloat16(1)
	@test BFloat16(2f0) >  BFloat16(1f0)
	@test BFloat16(2.0) >  BFloat16(1.0)
	@test BFloat16(2)   >= BFloat16(1)
	@test BFloat16(2f0) >= BFloat16(1f0)
	@test BFloat16(2.0) >= BFloat16(1.0)
	@test BFloat16(2)   != BFloat16(1)
	@test BFloat16(2f0) != BFloat16(1f0)
	@test BFloat16(2.0) != BFloat16(1.0)
	@test iszero(BFloat16(0)) == true
 	@test iszero(BFloat16(3.45)) == false
end

@testset "conversions" begin
	@test Float32(BFloat16(10)) == 1f1
	@test Float64(BFloat16(10)) == 10.0
	@test Int32(BFloat16(10)) == Int32(10)
	@test Int64(BFloat16(10)) == Int64(10)
end

@testset "functions" begin
	@test abs(BFloat16(-10)) == BFloat16(10)
	@test BFloat16(2) ^ BFloat16(4) == BFloat16(16)
	@test eps(BFloat16) == BFloat16(0.0078125)
	@test sqrt(BFloat16(4f0)) == BFloat16(2f0)
	@test round(BFloat16(10.4), RoundUp) == BFloat16(11.0)
	@test round(BFloat16(10.6), RoundDown) == BFloat16(10.0)
	@test round(BFloat16(3.2), RoundNearest) == BFloat16(3.0)
	@test round(BFloat16(4.8), RoundNearest) == BFloat16(5.0)
end

@testset "printf" begin
  for (fmt, val) in (("%7.2f", "   1.23"),
                     ("%-7.2f", "1.23   "),
                     ("%07.2f", "0001.23"),
                     ("%.0f", "1"),
                     ("%#.0f", "1."),
                     ("%.3e", "1.234e+00"),
                     ("%.3E", "1.234E+00"),
                     ("%.2a", "0x1.3cp+0"),
                     ("%.2A", "0X1.3CP+0")),
      num in (BFloat16(1.234),)
      @test @eval(@sprintf($fmt, $num) == $val)
  end
  @test (@sprintf "%f" BFloat16(Inf)) == "Inf"
  @test (@sprintf "%f" BFloat16(NaN)) == "NaN"
  @test (@sprintf "%.0e" BFloat16(3e2)) == "3e+02"
  @test (@sprintf "%#.0e" BFloat16(3e2)) == "3.e+02"

  for (fmt, val) in (("%10.5g", "     123.5"),
                     ("%+10.5g", "    +123.5"),
                     ("% 10.5g","     123.5"),
                     ("%#10.5g", "    123.50"),
                     ("%-10.5g", "123.5     "),
                     ("%-+10.5g", "+123.5    "),
                     ("%010.5g", "00000123.5")),
      num in (BFloat16(123.5),)
      @test @eval(@sprintf($fmt, $num) == $val)
  end
  @test( @sprintf( "%10.5g", BFloat16(-123.5) ) == "    -123.5")
  @test( @sprintf( "%010.5g", BFloat16(-123.5) ) == "-0000123.5")
  @test (@sprintf "%a" BFloat16(1.5)) == "0x1.8p+0"
end

@testset "Sign flip" begin
    @test one(BFloat16) == -(-(one(BFloat16)))
    @test zero(BFloat16) == -(zero(BFloat16))
end

@testset "Integer promotion" begin
    f = BFloat16(1)
    @test 2f == BFloat16(2)
    @test 0 == BFloat16(0)
end

@testset "Rounding" begin
    @test 1 == Int(round(BFloat16(1.2)))
    @test 1 == Int(floor(BFloat16(1.2)))
    @test 2 == Int(ceil(BFloat16(1.2)))

    @test -1 == Int(round(BFloat16(-1.2)))
    @test -2 == Int(floor(BFloat16(-1.2)))
    @test -1 == Int(ceil(BFloat16(-1.2)))
end

@testset "Nextfloat prevfloat" begin
    o = one(BFloat16)
    @test o == nextfloat(prevfloat(o))
    @test o == prevfloat(nextfloat(o))
end

@testset "Absolute values" begin
    @test abs(BFloat16(-10)) == BFloat16(10)
    @test abs(BFloat16(-0)) == BFloat16(0)
    @test abs(BFloat16(1)) == BFloat16(1)
end

@testset "Conversion float" begin
    fs = [1.0,2.5,10.0,0.0,-0.25,-5.0]

    for f in fs
        @test f == Float64(BFloat16(f))
        @test Float32(f) == Float32(BFloat16(f))
        @test Float16(f) == Float16(BFloat16(f))
    end
end

@testset "Conversion int" begin
    fs = [-5,-1,0,-0,1,2]

    for f in fs
        @test f == Int64(BFloat16(f))
        @test Int32(f) == Int32(BFloat16(f))
    end
end

@testset "Addition and subtraction" begin

    @test BFloat16(2) == BFloat16(1)+BFloat16(1)
    @test BFloat16(1) == BFloat16(1)+BFloat16(0)
    @test BFloat16(-1) == BFloat16(1)+BFloat16(-2)
    @test BFloat16(1.5) == BFloat16(1)+BFloat16(0.5)
    @test BFloat16(1.5) == BFloat16(2)-BFloat16(0.5)
    @test BFloat16(0) == BFloat16(1.2345)-BFloat16(1.2345)
    @test BFloat16(-1.5) == BFloat16(2.5)-BFloat16(4.0)
end

@testset "Multiplication" begin

    @test BFloat16(2) == BFloat16(2)*BFloat16(1)
    @test BFloat16(0) == BFloat16(1)*BFloat16(0)
    @test BFloat16(-2) == BFloat16(1)*BFloat16(-2)
    @test BFloat16(0.25) == BFloat16(0.5)*BFloat16(0.5)
    @test BFloat16(1.5) == BFloat16(3)*BFloat16(0.5)
    @test BFloat16(12.5) == BFloat16(1.25)*BFloat16(10.0)
    @test BFloat16(-12) == BFloat16(-10)*BFloat16(1.2)
    @test InfB16 == -InfB16*-InfB16
end

@testset "Division" begin

    @test BFloat16(2) == BFloat16(2)/BFloat16(1)
    @test BFloat16(0) == BFloat16(0)/BFloat16(1)
    @test BFloat16(-0.5) == BFloat16(1)/BFloat16(-2)
    @test BFloat16(1) == BFloat16(0.5)/BFloat16(0.5)
    @test BFloat16(1.5) == BFloat16(3)/BFloat16(2)
    @test BFloat16(-12.5) == BFloat16(-25)/BFloat16(2)
    @test InfB16 == BFloat16(1)/BFloat16(0)
    @test -InfB16 == BFloat16(-1)/BFloat16(0)
end

@testset "Power" begin
    @test BFloat16(2) ^ BFloat16(4) == BFloat16(16)
    @test BFloat16(4) ^ BFloat16(-2) == BFloat16(1/16)
end

@testset "Sqrt" begin
    @test sqrt(BFloat16(4f0)) == BFloat16(2f0)
    @test sqrt(BFloat16(1f0)) == BFloat16(1f0)
    @test sqrt(BFloat16(0.25)) == BFloat16(0.5)
end
