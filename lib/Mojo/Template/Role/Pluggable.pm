package Mojo::Template::Role::Pluggable;

use Mojo::Base -role;

use Mojo::Loader qw(data_section find_packages find_modules);
use Mojo::File qw/path/;
use Mojo::Util qw/monkey_patch class_to_path md5_sum/;
use Mojolicious::Plugins;
use Carp;

use strict;

$\ = "\n"; $, = "\t";


requires 'render';

has dirs => sub {
    [ reverse ('./templates', path(__FILE__ =~ s/\.pm$//r, 'templates')) ]
};

has renderer => sub { Mojo::Template->new->vars(1)->namespace('Mojo::Template::Role::Pluggable::Sandbox'); };

has plugins  => sub { Mojolicious::Plugins->new };

has deparser => sub { B::Deparse->new };

has helpers => sub { { } };


sub stash {
    my ($namespace, $var, $val) = @_;

    no strict 'refs';

    if (defined $val) {
	*{"$namespace\::$var"} = \$val;
    } else {
	$val = *{"$namespace\::$var"};
	return $$val;
    }
}

sub unique_ns {
    return join '::', __PACKAGE__, md5_sum(md5_sum(time() . {} . rand() . $$));
}

sub plugin {
    my $self = shift;
    my $plugin = shift;
    $self->plugins->register_plugin($plugin, $self, @_);
}

sub helper {
    my $self = shift;
    my $name = shift || croak "The helper name is required";
    my $sub  = shift || sub {};

    return if $self->helpers->{$name};
    
    $self->helpers->{$name} = $sub;
    my $class = ref $self;
    no strict 'refs';

    *{"$class\::$name"} = $sub;
}

sub find_template {
    my $self = shift;
    my ($name, $format) = @_;

    $format ||= 'html';
    my $suffix = 'ep';
    my $file_name = join '.', $name, $format, $suffix;

    for (reverse @{$self->dirs}) {
	my $file = path($_, $file_name);
	if (-f $file) { return $file->slurp }
    }
    return data_section(__PACKAGE__, $file_name)
}


around 'render' => sub {
    my $orig = shift;
    my $self = shift;
    
    my $ret = $self->render_with_helpers(@_);
    return $ret;
};

sub render_with_helpers {
    my $self = shift;
    my $template = shift;
    my $data = shift;
    
    if (ref $template) {
	if ($template->{inline}) {
	    $template = $template->{inline};	
	} else {
	    $template = $self->find_template($template->{template});	
	}
    } else {
	$template = $template;	
    }

    die Mojo::Exception->new("Cannot render an empty template!\n")->trace unless $template;;
    
    my $namespace = unique_ns();

    monkey_patch $namespace, layout => sub {
	my $ref = shift;
	stash($namespace, layout => $ref);
    };

    for my $helper (keys %{$self->helpers}) {
	monkey_patch $namespace, $helper => sub {
	    return $self->$helper($_[0]);
	};
    }

    $self->renderer($self->renderer->namespace($namespace));
    
    my $content = $self->renderer->render($template, $data);

    if (my $layout = stash($namespace, 'layout')) {
	$content = $self->render({ template => $layout }, { content => $content })
    }
    return $content;
}

1;
