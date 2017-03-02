defmodule PersistentEts.FileHelpers do
  import ExUnit.Assertions

  @doc """
  Returns the `tmp_path` for tests.
  """
  def tmp_path do
    Path.expand("../../tmp", __DIR__)
  end

  @doc """
  Executes the given function in a temp directory
  tailored for this test case and test.
  """
  defmacro in_tmp(fun) do
    path = Path.join([tmp_path(), "#{__CALLER__.module}", "#{elem(__CALLER__.function, 0)}"])
    quote do
      path = unquote(path)
      File.rm_rf!(path)
      File.mkdir_p!(path)
      File.cd!(path, fn -> unquote(fun).(path) end)
    end
  end

  @doc """
  Asserts a file was generated.
  """
  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end
end
