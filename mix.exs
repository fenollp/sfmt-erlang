defmodule Mix.Tasks.Compile.Sfmt do
  @shortdoc "Compiles Sfmt"
  
  def run(_) do
    File.mkdir("priv")
    {exec, args} = {"make", ["all"]}
    if System.find_executable(exec) do
      build(exec, args)
      Mix.Project.build_structure
      :ok
    else
      nocompiler_error(exec)
    end
  end

  def build(exec, args) do
    {result, error_code} = System.cmd(exec, args, stderr_to_stdout: true)
    IO.binwrite result
    if error_code != 0, do: build_error(exec)
  end

  defp nocompiler_error(exec) do
    raise Mix.Error, message: nocompiler_message(exec)
  end

  defp build_error(exec) do
    raise Mix.Error, message: build_message(exec)
  end

  defp nocompiler_message(exec) do
    """
    Could not find the compiler program `#{exec}`.
    """
  end

  defp build_message(exec) do
    """
    Could not build the program with `#{exec}`.
    """
  end
end

defmodule Sfmt.Mixfile do
  use Mix.Project

  def project do
    [app: :sfmt,
     version: "0.12.6",
     description: description,
     package: package,
     compilers: [:sfmt, :app],
     deps: deps]
  end

  def application do
    [applications: [:kernel, :stdlib, :logger]]
  end

  defp deps do
    []
  end

  defp description do
    """
    SIMD-oriented Fast Mersenne Twister (SFMT) for Erlang.
    """
  end

  defp package do
    [files: [
        "c_src",
        "reference_texts",
        "src",
        "test",
        "test_scripts",
        ".gitignore",
        ".travis.yml",
        "CHANGES.md",
        "CONTRIBUTING.md",
        "Doxyfile",
        "LICENSE",
        "Makefile",
        "Makefile.sfmt",
        "README.md",
        "erlang.mk",
        "mix.exs"
        ],
     maintainers: [
        "Kenji Rikitake"
        ],
     licenses: ["simplified BSD"],
     build_tools: ["make"],
     links: %{"GitHub" => "https://github.com/jj1bdx/sfmt-erlang/"}
     ]
  end
end
