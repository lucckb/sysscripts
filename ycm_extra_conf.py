import os
import ycm_core
from clang_helpers import PrepareClangFlags

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
def find_build_folder():
    current = '.build.json'
    for i in range(10):
        if os.path.exists(current):
            return current
        current = '../' + current
    return ''

# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = find_build_folder()

# These are the compilation flags that will be used in case there's no
# compilation database set.
flags = [
'-Wall',
'-Wextra',
'-Wno-variadic-macros',
'-fexceptions',
'-nostdinc',
'-std=c++17',
'-x', 'c++',
]
# For check the compiler paths call `gcc -print-prog-name=cc1plus` -v
# Compatibility with clang complete
if os.path.isfile('.clang_complete'):
    with open('.clang_complete') as clf:
        content = clf.read().splitlines()
        flags += content
else:
    flags += [
            '-I',
            '/usr/include'
            '-isystem',
            '/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/../../../../include/c++/8.2.1'
            '-isystem',
            '/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/../../../../include/c++/8.2.1/x86_64-pc-linux-gnu',
            '-isystem',
            '/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/../../../../include/c++/8.2.1/backward',
            '-isystem',
            '/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include',
            '-isystem',
            '/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include-fixed',
            '-I',
            '/usr/local/include',
        ]


if compilation_database_folder:
    database = ycm_core.CompilationDatabase(compilation_database_folder)
else:
    database = None


#def DirectoryOfThisScript():
#    return os.path.dirname(os.path.abspath(__file__))

def DirectoryOfThisScript():
    return os.path.abspath(os.getcwd())


def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return flags
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForFile(filename):
    if database:
        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object
        compilation_info = database.GetCompilationInfoForFile(filename)
        final_flags = PrepareClangFlags(
            MakeRelativePathsInFlagsAbsolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_),
            filename)
    else:
        relative_to = DirectoryOfThisScript()
        final_flags = MakeRelativePathsInFlagsAbsolute(flags, relative_to)

    return {
        'flags': final_flags,
        'do_cache': True}
