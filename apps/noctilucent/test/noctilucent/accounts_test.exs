defmodule Noctilucent.AccountsTest do
  use Noctilucent.DataCase

  alias Noctilucent.Accounts

  describe "users" do
    alias Noctilucent.Accounts.User

    import Noctilucent.AccountsFixtures

    @invalid_attrs %{info: nil, status: nil, nickname: nil, username: nil, hashed_password: nil, gender: nil, gender_visible: nil, avater: nil, current: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    # get_user_by_username/1

    # get_user_by_username_and_password/2

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{info: "some info", status: :normal, nickname: "some nickname", username: "some username", hashed_password: "some hashed_password", gender: :male, gender_visible: true, avater: "some avater", current: "some current"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.info == "some info"
      assert user.status == :normal
      assert user.nickname == "some nickname"
      assert user.username == "some username"
      assert user.hashed_password == "some hashed_password"
      assert user.gender == :male
      assert user.gender_visible == true
      assert user.avater == "some avater"
      assert user.current == "some current"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{info: "some updated info", status: :frozen, nickname: "some updated nickname", username: "some updated username", hashed_password: "some updated hashed_password", gender: :female, gender_visible: false, avater: "some updated avater", current: "some updated current"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.info == "some updated info"
      assert user.status == :frozen
      assert user.nickname == "some updated nickname"
      assert user.username == "some updated username"
      assert user.hashed_password == "some updated hashed_password"
      assert user.gender == :female
      assert user.gender_visible == false
      assert user.avater == "some updated avater"
      assert user.current == "some updated current"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
