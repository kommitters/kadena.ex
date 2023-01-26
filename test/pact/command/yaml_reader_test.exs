defmodule Kadena.Pact.Command.YamlReaderTest do
  @moduledoc """
  `Pact.Command.YamlReader` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.Command.YamlReader

  describe "read_yaml/1" do
    setup do
      yaml_result =
        {:ok,
         %{
           "code" =>
             ";;\n;; \"Hello, world!\" smart contract/module\n;;\n\n(namespace \"free\")\n\n;;---------------------------------\n;;\n;;  Create an 'admin-keyset' and add some key, for loading this contract!\n;;\n;;  Make sure the message is signed with this added key as well.\n;;\n;;  When deploying new contracts, ensure to use a *unique keyset name*\n;;  and *unique module name* from any previously deployed contract\n;;\n;;\n;;---------------------------------\n\n\n;; Keysets cannot be created in code, thus we read them in\n;; from the load message data.\n(define-keyset \"free.admin-keyset\" (read-keyset \"admin-keyset\"))\n\n;; Define the module. The module name must be unique\n(module hello-world GOV\n  \"A smart contract to greet the world.\"\n\n  ;; Define module governance function\n  (defcap GOV ()\n    (enforce-keyset \"free.admin-keyset\"))\n\n  (defun hello (name:string)\n    \"Do the hello-world dance\"\n    (format \"Hello {}!\" [name]))\n)\n\n;; and say hello!\n(hello \"world\")\n",
           "data" => %{
             "admin-keyset" => %{
               "keys" => [
                 "1ead010c9e035055d125a952dbb218a81fff424631f0a5213cba21d4ddeb7426",
                 "6ab0d95465ae7c97c38bb04e61e9a7e09b669bb8fdf528ea4b82593b5f15b582",
                 "8a3990fc3621cca9cc0f303712053b1369519f5b09eea3667b28335d32dcc4ff",
                 "dddf8ac79971a3fd9085cafa06de30ee558d105b5f231200c36e0ddaef616244",
                 "e18a5b967c0a195c1f9e361b01633a32f0ae8480b749d78ff15746d55395ea1a",
                 "e83789c5964fa7a31525564fdf43e4c018ce2787a3a0d614839e6603fb434aba",
                 "eeb9b43396227ef0502a69658645c03103b438d8bcdf46bd919b6af8cf51896d"
               ],
               "pred" => "keys-all"
             },
             "free.admin-keyset" => %{"keys" => [], "pred" => "keys-all"}
           }
         }}

      without_code_result =
        {:ok,
         %{
           "data" => %{
             "admin-keyset" => %{
               "keys" => [
                 "1ead010c9e035055d125a952dbb218a81fff424631f0a5213cba21d4ddeb7426",
                 "6ab0d95465ae7c97c38bb04e61e9a7e09b669bb8fdf528ea4b82593b5f15b582",
                 "8a3990fc3621cca9cc0f303712053b1369519f5b09eea3667b28335d32dcc4ff",
                 "dddf8ac79971a3fd9085cafa06de30ee558d105b5f231200c36e0ddaef616244",
                 "e18a5b967c0a195c1f9e361b01633a32f0ae8480b749d78ff15746d55395ea1a",
                 "e83789c5964fa7a31525564fdf43e4c018ce2787a3a0d614839e6603fb434aba",
                 "eeb9b43396227ef0502a69658645c03103b438d8bcdf46bd919b6af8cf51896d"
               ],
               "pred" => "keys-all"
             },
             "free.admin-keyset" => %{"keys" => [], "pred" => "keys-all"}
           }
         }}

      without_data_result =
        {:ok,
         %{
           "code" =>
             ";;\n;; \"Hello, world!\" smart contract/module\n;;\n\n(namespace \"free\")\n\n;;---------------------------------\n;;\n;;  Create an 'admin-keyset' and add some key, for loading this contract!\n;;\n;;  Make sure the message is signed with this added key as well.\n;;\n;;  When deploying new contracts, ensure to use a *unique keyset name*\n;;  and *unique module name* from any previously deployed contract\n;;\n;;\n;;---------------------------------\n\n\n;; Keysets cannot be created in code, thus we read them in\n;; from the load message data.\n(define-keyset \"free.admin-keyset\" (read-keyset \"admin-keyset\"))\n\n;; Define the module. The module name must be unique\n(module hello-world GOV\n  \"A smart contract to greet the world.\"\n\n  ;; Define module governance function\n  (defcap GOV ()\n    (enforce-keyset \"free.admin-keyset\"))\n\n  (defun hello (name:string)\n    \"Do the hello-world dance\"\n    (format \"Hello {}!\" [name]))\n)\n\n;; and say hello!\n(hello \"world\")\n"
         }}

      %{
        path: "test/support/yaml_tests_files/",
        yaml_result: yaml_result,
        without_code_result: without_code_result,
        without_data_result: without_data_result
      }
    end

    test "when yaml file has code and data values", %{path: path, yaml_result: yaml_result} do
      ^yaml_result = YamlReader.read_yaml(path <> "with_values.yaml")
    end

    test "when yaml file has code and data files", %{path: path, yaml_result: yaml_result} do
      ^yaml_result = YamlReader.read_yaml(path <> "with_files.yaml")
    end

    test "without code nor code_file", %{path: path, without_code_result: without_code_result} do
      ^without_code_result = YamlReader.read_yaml(path <> "with_files_no_code.yaml")
    end

    test "without data nor data_file", %{path: path, without_data_result: without_data_result} do
      ^without_data_result = YamlReader.read_yaml(path <> "with_files_no_data.yaml")
    end

    test "without code_file and data_file set", %{path: path} do
      {:ok, %{}} = YamlReader.read_yaml(path <> "with_files_not_set.yaml")
    end

    test "without code and data set", %{path: path} do
      {:ok, %{}} = YamlReader.read_yaml(path <> "with_values_not_set.yaml")
    end

    test "error with an invalid code_file", %{path: path} do
      {:error, [code_file: :not_a_pact_file]} =
        YamlReader.read_yaml(path <> "with_files_code_error.yaml")
    end

    test "error with an invalid data_file", %{path: path} do
      {:error, [data_file: :not_a_json_file]} =
        YamlReader.read_yaml(path <> "with_files_data_error.yaml")
    end

    test "error with a non existing yaml", %{path: path} do
      {:error,
       %YamlElixir.FileNotFoundError{
         message:
           "Failed to open file \"test/support/yaml_tests_files/non_existent.yaml\": no such file or directory"
       }} = YamlReader.read_yaml(path <> "non_existent.yaml")
    end
  end
end
