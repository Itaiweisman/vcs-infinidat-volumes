## UNIX/LINUX Version
package infinidatibox;
use REST::Client;
use JSON;
use ag_i18n_inc;
use MIME::Base64;
use Data::Dumper;
use Exporter qw(import);
our @EXPORT_OK = qw(check_pars switchRoleFromLocal getInfiniBoxSingleObjectByNames);

#### @par_list =qw(key1 1 val1 key2 1 val2 key3 3 a b c key4 1 t key5 0  key6 3 g h i key7 1 sof);
#### %required_has_type =('key1' => 'scalar', 'key2' => 'scalar', 'key3' => 'vector', 'key4' => 'vector', 'key5' => 'scalar', 'key6' => 'vector', 'key7' => 'scalar');


sub check_pars {
        my ($par_list_ref,$required_pars_ref)=@_;
        my @par_list=@ { $par_list_ref };
        my %required_pars_hash=% { $required_pars_ref };
        my %pars;
        my $temp_index;
        while (@par_list) {

                $name=shift @par_list;
                $count=shift @par_list;
                #$val=shift @par_list;
                #print "DEBUG  === $name $count  \n";
                last if (! length "$count");
                
                if (grep {/$name/} (keys %required_pars_hash)) {
                    #print "DEBUG working on $name which is $required_pars_hash{$name} \n";
                    if ($count == 0) {  $pars{$name} =0; next ; }
                    if ($required_pars_hash{$name} eq 'vector') {
                       $pars{$name}=();
                       #push @{ $par{$name} },$val;
                       #print "DEBUG setting $name as vector \n";  
                       $temp_index=1;
                       while ($temp_index le $count) {
                         $val=shift @par_list;
                         #print "DEBUG ====> Adding value of $val to $name  \n";
                         push (@ { $pars{$name} },$val );
                         $temp_index++;
                       }


                    
                }
                if  ($required_pars_hash{$name} eq 'scalar') { 
                    $val=shift @par_list;
                    #print "DEBUG setting $name as scalar with value of $val \n"; 

                    $pars{$name}=$val; 
                }

            }
        }


        

        for $req(keys %required_pars_hash) {
                if (! grep {/$req/} keys %pars ) {
                    #VCSAG_LOG_MSG("E","Mandatory key $req does not exist!",11);
                    print "problem! with $req \n";
                    return {};
                    }
                }
        return %pars;
        
        }

sub getInfiniBoxSingleObjectByName {

        my $ResName=shift;
        VCSAG_SET_ENVS ($ResName, 20091);


        my $host=shift;
        my $user=shift;
        my $password=shift;
        my $objtype=shift;
        my $object=shift;
        my $namevar=shift;
        my @result=[];
        $namevar = defined $namevar ? $namevar : "name" ;
        my $EncPword = VCSAG_SQUEEZE_SPACES($password);
        our $DecPword = `$ag_i18n_inc::HADECRYPT $EncPword`;
	       #$DecPword=$password;
        our $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $DecPword)};
        my $client = REST::Client->new();
        $client->setHost("http://$host");
        my $uri="/api/rest/". $objtype . "?" . $namevar ."=" .$object;
        $client->GET( $uri, $headers);
        $ok = eval {$response = from_json($client->responseContent());1};
	if (! $ok ) {
        VCSAG_LOG_MSG("E","Caught Error - Can't get response from $host",3001);
		  return 0 ;
	}
        @result=$response->{'result'};
        @error=$response->{'error'};
        if ( @{$result[0]} )  {
                VCSAG_LOG_MSG("I","Response from http://${host}/${uri} is not empty",1001);
                #print   "Response is not empty \n";
                 }
        else {
                VCSAG_LOG_MSG("W","Response from http://${host}/${uri} is empty",2001);
                #print   "Response is empty \n";
                if ($error[0]{'code'}) {
                        VCSAG_LOG_MSG("E","Caught Error - $error[0]{'message'}",3002);
                        #print   "Caught Error - $error[0]{'message'} \n";
                }
                return {};
                }
        #return @result;

	return $result[0][0];
}


sub switchRoleFromLocal {
    $ResName=shift;
    VCSAG_SET_ENVS ($ResName, 20091);

    my $host=shift;
    my $user=shift;
    my $password=shift;
    my $id=shift;
     my $EncPword = VCSAG_SQUEEZE_SPACES($password);
    our $DecPword = `$ag_i18n_inc::HADECRYPT $EncPword`;
    #$DevPword=$passowrd;
    our $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $DecPword)};
    my $uri="/api/rest/replicas/".$id."/switch_role?approved=true";
        my $post = REST::Client->new();
        $post->setHost("http://$host");
        $post->POST ( $uri,'{}', $headers);
        $ok = eval {$response = from_json($post->responseContent());1};
        if (! $ok ) {
         VCSAG_LOG_MSG("E","Caught Error - Can't get response from $host",3101);
        #print   "Caught Error - Can't get response from $host" ;  return 0 ;
        }
        @result=$response->{'result'};
        @error=$response->{'error'};
        if ( $result[0])   {
                #print "Response is not empty \n";
                VCSAG_LOG_MSG("I","Response from http://${host}/${uri} is not empty",13);


                 }
        else {
                #print "Response is empty \n";
                 VCSAG_LOG_MSG("E","Response from http://${host}/${uri} is  empty",13);
                if ($error[0]{'code'}) {
                        #print "Caught Error - $error[0]{'message'} \n";
                       VCSAG_LOG_MSG("E","Caught Error - $error[0]{'message'}",7);

                }
                return 0;
                }
        return 1;
}
1;
