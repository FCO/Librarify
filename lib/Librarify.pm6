use v6.d;

multi EXPORT(&sub) is export {
    my %cmds is Map = do for &sub.candidates>>.signature>>.params {
        my @params = .self;
        my @cmd;
        my @data = @params.map(-> Parameter $param {
            do given $param.constraint_list {
                do if .elems == 1 && .head ~~ (Str|Int) {
                    @cmd.push: .head;
                    .head
                } else {
                    * if $param.positional
                }
            }
        });

        "&" ~ @cmd.join("-") => &sub.assuming(|@data) if @cmd
    }
    Map.new: '&lib-funcs' => sub { %cmds },
}
