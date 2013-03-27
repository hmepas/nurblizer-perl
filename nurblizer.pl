use Mojolicious::Lite;

{
    my $nouns;
    sub _nouns {
        unless($nouns) {
            open(my $NOUNS, "nouns.txt")
                or die "$!";
            while(<$NOUNS>) {
                chomp;
                $nouns->{$_} = 1;
            }
            close($NOUNS);
        }
        $nouns;
    }
}
sub _nurbilize_word {
    _nouns->{$_[0]} ? $_[0] : 'nurble'
}

sub nurbilize {
    my $text = shift;
    my $nouns = _nouns();
    $text =~ s/\b(\w+)\b/&_nurbilize_word($1)/ge;
    return $text;
}

get '/' => sub {
    my $self = shift;
    $self->render('index');
};

post '/' => sub {
    my $self = shift;
    $self->stash(
        nurbled_text => nurbilize( $self->param('text') )
    );
    $self->render('nurblized');
};

app->start;

__DATA__

@@ index.html.ep
% layout 'main';
<h1>Nurblizer</h1>
<form action="/" method="post">
    <fieldset>
        <ul>
            <li>
                <label>Text to nurblize</label>
                <textarea name="text"></textarea>
            </li>
            <li>
                <input type="submit" value="Nurblize Away!">
            </li>
        </ul>
    </fieldset>
</form>
<p>
    <a href="http://www.smbc-comics.com/?id=2779">wtf?</a>
</p>
 
@@ nurblized.html.ep
% layout 'main';
<h1>Your Nurbled Text</h1>
<div><%= $nurbled_text %></div>
<p>
    <a href="/">&lt;&lt; Back</a>
</p>


@@ layouts/main.html.ep
<!DOCTYPE html>
<html>
    <head>
        <title><%= title . " / " if title %>Nurblizer</title>
        <style>
            fieldset {
                margin: 0 0;
                border: none;
            }
            fieldset ul {
                list-style-type: none;
            }
            fieldset label {
                display: block;
            }
            fieldset textarea {
                width: 400px;
                height: 200px;
            }
        </style>
    </head>
    <body><%= content %></body>
</html>
