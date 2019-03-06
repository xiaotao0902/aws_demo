var token_url = 'http://a8f74d8be3e5d11e9aae4065bc1c319a-84845737.ap-northeast-1.elb.amazonaws.com:8000/auth';
var product_url = 'http://a5efc20953e5d11e9aae4065bc1c319a-1676813558.ap-northeast-1.elb.amazonaws.com:9000/product';

function init(){
	var token = getOauthTokenFromStorage();
	if (token==null||token=='') {
    	window.location.href="login.html"
    } 
}
function search() {
	$.ajax({
		url: product_url + '?access_token=' + getOauthTokenFromStorage(),
		type: 'get',
		async: false,
		success: function (data) {
			var item;
			$.each(data, function(i, result) {
				item = "<tr><td>" + result['id'] + "</td><td>" + result['name'] + "</td><td>" + result['price'] + "</td></tr>";
				$('#result').append(item);
			});
		},
		error: function () {
		}
	});
}


function login() {

    var username = $("input[id='name']").val();
    var password = $("input[id='password']").val();

    if (requestOauthToken(username, password)) {
    	window.location.href="home.html"
    } else {
        alert("Something went wrong. Please, check your credentials");
    }
}


/**
 * Oauth2
 */

function requestOauthToken(username, password) {

	var success = false;

	$.ajax({
		url: token_url,
		type: 'post',
		headers: {'Authorization': 'Basic cGFzc3dvcmRfYXV0aF9tb2RlOnBhc3N3b3JkX2F1dGhfbW9kZQ=='},
		async: false,
		data: {
			scope: 'read',
			username: username,
			password: password,
			grant_type: 'password'
		},
		success: function (data) {
			localStorage.setItem('token', data.access_token);
			success = true;
		},
		error: function () {
			removeOauthTokenFromStorage();
		}
	});

	return success;
}

function getOauthTokenFromStorage() {
	return localStorage.getItem('token');
}

function removeOauthTokenFromStorage() {
    return localStorage.removeItem('token');
}

