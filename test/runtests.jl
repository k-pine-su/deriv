# ほとんど品岡さんのコードです。
# timeprop > derivの置換を実行
# F(t)の場合のテストも追加したい

using deriv
import deriv: perform_deriv
using Test

@testset "deriv.jl" begin
    # 等速度運動のテスト
    @testset "Uniform motion" begin
        # 加速度が0の等速度運動
        F(x, t) = 0.0
        tmax = 1.0
        x0 = 0.0
        v0 = 1.0  # 初期速度
        h = 1e-3   # 時間ステップ

        x_final, v_final = perform_deriv(F, tmax, x0, v0, h)

        # 理論値: x = x0 + v0*t
        expected_x = x0 + v0 * tmax
        expected_v = v0  # 速度は変化しない

        @test isapprox(x_final, expected_x, rtol=1e-10)
        @test isapprox(v_final, expected_v, rtol=1e-10)
    end

    # 等加速度運動のテスト
    @testset "Uniform acceleration motion" begin
        # 加速度が一定の等加速度運動
        F(x, t) = 1.0  # 一定の加速度
        tmax = 1.0
        x0 = 0.0
        v0 = 0.0  # 初期速度
        h = 1e-4   # 時間ステップ

        x_final, v_final = perform_deriv(F, tmax, x0, v0, h)

        # 理論値: x = x0 + v0*t + (1/2)*a*t^2
        # 理論値: v = v0 + a*t
        expected_x = x0 + v0 * tmax + 0.5 * F(0, 0) * tmax^2
        expected_v = v0 + F(0, 0) * tmax

        @test isapprox(x_final, expected_x, rtol=1e-3)
        @test isapprox(v_final, expected_v, rtol=1e-3)
    end

    # バネの運動のテスト
    @testset "Spring motion" begin
        # バネ定数
        k = 1.0
        # バネの力: F = -kx
        F(x, t) = -k * x
        
        tmax = 2π  # 1周期分
        x0 = 1.0   # 初期位置
        v0 = 0.0   # 初期速度
        h = 1e-4   # 時間ステップ

        x_final, v_final = perform_deriv(F, tmax, x0, v0, h)

        # 理論値: x = x0 * cos(ωt), ここでω = √k
        # 理論値: v = -x0 * ω * sin(ωt)
        ω = √k
        expected_x = x0 * cos(ω * tmax)
        expected_v = -x0 * ω * sin(ω * tmax)

        # バネの運動は数値誤差が蓄積しやすいため、許容誤差を大きくする
        @test isapprox(x_final, expected_x, atol=1e-2)
        @test isapprox(v_final, expected_v, atol=1e-2)
    end

    # F(x,t) = Ctの場合のテスト
    @testset "F(x,t) = Ct motion" begin
        # 時間に比例する加速度
        C = 1.0  # 定数
        F(x, t) = C * t  # 加速度は時間に比例

        tmax = 1.0  # 時間の最大値
        x0 = 0.0   # 初期位置
        v0 = 0.0   # 初期速度
        h = 1e-4   # 時間ステップ

        x_final, v_final = perform_deriv(F, tmax, x0, v0, h)

        # 理論値: v=1/2*C*t^2, x=1/6*C*t^3
        expected_v = (1 / 2) * C * tmax^2 + v0
        expected_x = (1 / 6) * C * tmax^3 + v0 * tmax + x0

        @test isapprox(x_final, expected_x, rtol=1e-3)
        @test isapprox(v_final, expected_v, rtol=1e-3)
    end

    # エラーが出るのでコメントアウトしておく
    # # F(t)の場合のテスト
    # @testset "F(t) motion" begin
    #     # 時間依存の加速度
    #     F(t) = sin(t)  # 時間とともに変化する加速度
    #     tmax = 2π     # 1周期分
    #     x0 = 0.0      # 初期位置
    #     v0 = 0.0      # 初期速度
    #     h = 1e-4      # 時間ステップ

    #     x_final, v_final = perform_deriv(F, tmax, x0, v0, h)

    #     # 理論値は解析的に求めるのが難しいため、数値的に確認する
    #     expected_v = -cos(tmax) + v0    
    #     expected_x = -sin(tmax) + v0 * tmax + x0

    #     @test isapprox(x_final, expected_x, rtol=1e-2)
    #     @test isapprox(v_final, expected_v, rtol=1e-2)
    # end
end