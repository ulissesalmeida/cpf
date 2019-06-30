# Remove me when release 1.0.0
defmodule CPF.CastingError do
  defexception reason: nil

  @type t :: %__MODULE__{reason: :invalid_verifier | :too_long | :same_digits | :invalid_format}

  def message(%__MODULE__{reason: reason}), do: to_string(reason)
end
