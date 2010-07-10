package Facebook::Graph::Authorize;

use Any::Moose;
with 'Facebook::Graph::Role::Uri';

has app_id => (
    is      => 'ro',
    required=> 1,
);

has postback => (
    is      => 'ro',
    required=> 1,
);

has permissions => (
    is          => 'rw',
    lazy        => 1,
    predicate   => 'has_permissions',
    default     => sub { [] },
);

has display => (
    is      => 'rw',
    default => 'page',
);

sub extend_permissions {
    my ($self, @permissions) = @_;
    push @{$self->permissions}, @permissions;
    return $self;
}

sub set_display {
    my ($self, $display) = @_;
    $self->display($display);
    return $self;
}

sub uri_as_string {
    my ($self) = @_;
    my $uri = $self->uri;
    $uri->path('oauth/authorize');
    my %query = (
        client_id       => $self->app_id,
        redirect_uri    => $self->postback,
        display         => $self->display,
    );
    if ($self->has_permissions) {
        $query{scope} = join(',', @{$self->permissions});
    }
    $uri->query_form(%query);
    return $uri->as_string;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;


=head1 NAME

Facebook::Graph::Authorize - Authorizing an app with Facebook

=head1 METHODS

=head2 extend_permissions ( permissions )

Ask for extra permissions for your app. Returns a reference to self for method chaining.

=head3 permissions

An array of permissions. See L<http://developers.facebook.com/docs/authentication/permissions> for more information about what's available.


=head2 set_display ( type )

Sets the display type for the authorization screen that a user will see.

=head3 type

Defaults to C<page>. Valid types are C<page>, C<popup>, C<wap>, and C<touch>. See B<Dialog Form Factors> in L<http://developers.facebook.com/docs/authentication/> for details.


=head2 uri_as_string ( )

Returns a URI string to redirect the user back to Facebook.



=head1 LEGAL

Facebook::Graph is Copyright 2010 Plain Black Corporation (L<http://www.plainblack.com>) and is licensed under the same terms as Perl itself.

=cut
