<?php
function send_request($uri, array $options = array()) {
	global $config;

  $curl_options = array(CURLOPT_USERAGENT => $config['user_agent'],
                        CURLOPT_TIMEOUT => 5,
                        CURLOPT_USERPWD => $config['username'] . ':' . $config['password'],
                        CURLOPT_RETURNTRANSFER => true);
  if (!empty($options)) {
      $curl_options = $curl_options + $options;
  }

  $request = curl_init($uri);
  curl_setopt_array($request, $curl_options);
  $response = curl_exec($request);
  curl_close($request);

  return $response;
}

function get_create_repo_body($name) {
    $data = array('name' => $name,
                  'description' => 'Website',
                  'homepage' => 'http://' . $name,
                  'private' => true);

    return json_encode($data);
}

if ($argc != 2) {
	echo 'Expected repository name';
	exit(1);
}

$config = parse_ini_file('config.ini');
print_r($config);

// create repo
$repo_name = $argv[1];
$json_payload = get_create_repo_body($repo_name);
$curl_options = array(CURLOPT_CUSTOMREQUEST => "POST",
                      CURLOPT_POSTFIELDS => $json_payload,
                      CURLOPT_HTTPHEADER => array('Content-Type: application/json', 'Content-Length: ' . strlen($json_payload)));
$response = send_request($config['host'] . "/orgs/{$config['organization']}/repos", $curl_options);
$data = json_decode($response, true);

if (!isset($data['id'])) {
	echo 'Failed to create GitHub repo.';
	exit(1);
}

// add team access
foreach ($config['team_ids'] as $team_id) {
  $response = send_request($config['host'] . "/teams/{$team_id}/repos/{$config['organization']}/{$data['name']}", array(CURLOPT_CUSTOMREQUEST => "PUT", CURLOPT_POSTFIELDS => ''));
  if (!empty($response)) {
		echo 'Failed to add ', $data['name'], ' to team (', $team_id, ')';
  }
}

echo $data['ssh_url'];
exit(0);
