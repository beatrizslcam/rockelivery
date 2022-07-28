defmodule Rockelivery.User do
  use Ecto.Schema
  import Ecto.Changeset

 @fields_that_can_be_changed [
  :address,
  :age,
  :cep,
  :cpf,
  :name,
  :password

 @required_fields [
  :address,
  :age,
  :cep,
  :cpf,
  :name,
  :password
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :address, :string
    field :age, :integer
    field :cep, :string
    field :cpf, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true,
    field :password_hash, :string


    timestamps()
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, @fields_that_can_be_changed)
    |> validate_required(@required_fields)
    |> valitade_lentgh(:password_hash,min: 6)
    |> valitade_lentgh(:cep,min: 8)
    |> valitade_lentgh(:cpf,min: 11)
    |> valitade_number(:age,greater_than_or_equal_to: 18)
    |> valitade_format(:email,~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:cpf)
    |>put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %%{password}} =changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

end
