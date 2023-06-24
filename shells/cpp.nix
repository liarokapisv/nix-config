{ mkShell, conan, cmake, ninja, llvmPackages, gcc }:

# We use the unwrapped clangd version because the wrapper uses
# the CPATH & CPLUS_INCLUDE_PATH env variables to pass the proper 
# header file paths. These override the --query-driver options.
# We tend to invoke clangd with --query-driver=** so that it automatically
# uses the include paths of the invoked compiler. This helps with cross-compiling.

mkShell {
  nativeBuildInputs = [
    conan
    cmake
    ninja
    llvmPackages.clang-unwrapped
    gcc
  ];
}

