print qq(/* THIS FILE WAS AUTOGENERATED BY STUBGEN.PL --- DO NOT EDIT BY HAND!!! */\n\n);
print qq(#include "owl.h");

foreach $file (@ARGV) {
    open(FILE, $file);

    print "/* -------------------------------- $file -------------------------------- */\n";
    while (<FILE>) {
	if (m|^\s*OWLVAR_([A-Z_0-9]+)\s*\(\s*"([^"]+)"\s*/\*\s*%OwlVarStub:?([a-z0-9_]+)?\s*\*/|) {   # "
    my $vartype = $1;
    my $varname = $2;
    my $altvarname = $2;
    $altvarname = $3 if ($3);
    my $detailname = $altvarname;
    $detailname =~ s/[^a-zA-Z0-9]/-/g;
    $detailname =~ s/^[^a-zA-Z]+//;
    if ($vartype =~ /^BOOL/) {
        print <<EOT;
void owl_global_set_${altvarname}_on(owl_global *g) {
  g_object_set(G_OBJECT(g->gn), "$detailname", TRUE, NULL);
}
void owl_global_set_${altvarname}_off(owl_global *g) {
  g_object_set(G_OBJECT(g->gn), "$detailname", FALSE, NULL);
}
int owl_global_is_$altvarname(const owl_global *g) {
  return owl_variable_get_bool(&g->vars, "$varname");
}
EOT
    } elsif ($vartype =~ /^PATH/ or $vartype =~ /^STRING/) {
        print <<EOT;
void owl_global_set_${altvarname}(owl_global *g, const char *text) {
  g_object_set(G_OBJECT(g->gn), "$detailname", text, NULL);
}
const char *owl_global_get_$altvarname(const owl_global *g) {
  return owl_variable_get_string(&g->vars, "$varname");
}
EOT
    } elsif ($vartype =~ /^INT/ or $vartype =~ /^ENUM/) {
        print <<EOT;
void owl_global_set_${altvarname}(owl_global *g, int n) {
  g_object_set(G_OBJECT(g->gn), "$detailname", n, NULL);
}
int owl_global_get_$altvarname(const owl_global *g) {
  return owl_variable_get_int(&g->vars, "$varname");
}
EOT
    } 
    }
    }
    close(FILE);
    print "\n";
}
