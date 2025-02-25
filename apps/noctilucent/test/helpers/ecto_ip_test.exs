defmodule EctoIpTest do
  use ExUnit.Case

  # 这测试用例不大好写，原来是用 GPT 生成的
  import EctoIP, only: [cast: 1, load: 1, dump: 1]

  describe "cast/1" do
    test "可解析的 IP 地址" do
      # IPv4
      assert {:ok, "127.0.0.1"} == cast("127.0.0.1")
      assert {:ok, "198.128.1.101"} == cast("198.128.1.101")
      # IPv6
      assert {:ok, "::1"} == cast("::1")

      assert {:ok, "127.0.0.1"} == EctoIP.cast({127, 0, 0, 1})
    end

    test "非法内容" do
      # 像 IP 地址的东西
      assert :error == cast("127.0.0.256")

      # 完全不像的
      assert :error == cast("My name's Glenn Quagmire, and I say gigitty.")
      assert :error == cast({1, 2, 3, 4, 5, 6, 7, :do, :while})
      assert :error == cast([])
    end
  end

  describe "load/1" do
    test "正常的" do
      assert {:ok, {127, 0, 0, 1}} == load("127.0.0.1")
    end

    test "有问题的" do
      assert :error == load("127.0.0.256")
    end
  end

  describe "dump/1" do
    test "正常的" do
      assert {:ok, "127.0.0.1"} == dump("127.0.0.1")
      assert {:ok, "127.0.0.1"} == dump({127, 0, 0, 1})
    end

    test "有问题的" do
      assert :error == dump([])
    end
  end
end
