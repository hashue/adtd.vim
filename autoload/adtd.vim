
function! adtd#getAllTask() abort
    let token = get(g:, 'adtd_token', '')
	let method = 'GET' 
	let curl=printf('curl -X %s  -Ss https://api.todoist.com/rest/v1/tasks  -H "Authorization: Bearer %s"',method,token)

	let res = system(curl)

	let task_info = {}
	let decoded = json_decode(res)

	let i = 0
	while i < len(decoded)
		let task_info.taskName = decoded[i]["content"]
		let task_info.id = decoded[i]["id"]
		let task_info.no = i

		echo task_info 
		let i += 1 
	endwhile

	let selected = input("Which one do you want to delete? ")
	let needDelId =  decoded[selected]["id"]

	let confirmDelete = input("\nAre you sure you want to delete? [y/n]\n")

	let method = 'DELETE'

	if confirmDelete == 'y'
		call adtd#execDelete(method,needDelId,token)
	elseif confirmDelete == 'n'
		echo "\ncanceled"
	endif


endfunction

function! adtd#execDelete(method,id,token) abort
	let curl=printf('curl -X %s  -Ss https://api.todoist.com/rest/v1/tasks/%s  -H "Authorization: Bearer %s"',a:method,a:id,a:token)

	let res = system(curl)
	echo "\ncomplete"
endfunction

" 
function! adtd#addTask() abort
	let taskName = input("task name :")

	let option = {
	\ "content" : taskName,
	\}

	let json_data =printf("--data '%s'",json_encode(option))
    let token = get(g:, 'adtd_token', '')
	let method = 'POST'
	let curl=printf('curl -X %s %s -Ss https://api.todoist.com/rest/v1/tasks  -H "Content-Type: application/json" -H "Authorization: Bearer %s"',method,json_data,token)

	let res = system(curl)
	let decoded_res = json_decode(res)

	echo "\ncreated task :".'name :'. decoded_res["content"].' '.'url :'.decoded_res["url"]

endfunction

