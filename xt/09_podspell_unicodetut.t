use Test::More;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
add_stopwords(<DATA>);
set_spell_cmd(
    "sp_ch () {(cat $1|aspell --lang=ru-yo list|aspell --lang=en list); };sp_ch"
);
all_pod_files_spelling_ok('lib/POD2/RU/perlunitut.pod');

