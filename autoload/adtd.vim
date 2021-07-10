function! adtd#getAllProject() abort
  let res = adtd#execCurl('GET_PROJECT',0)
  let project_info = {}

  let i = 0

  while i < len(res)
    let project_info.projectName = res[i]["name"]
    let project_info.id = res[i]["id"]
    let project_info.no = i
    echo printf("[%s] %s\n",project_info.no,project_info.projectName)
    let i += 1
  endwhile


  let selected = input("Which one do you want to check project? ")
  let need_to_see_project =  res[selected]["id"]


  let project_name = res[selected]["name"]
  let res = adtd#execCurl('GET',0)

  echo "\nProject Name :".project_name


  while i < len(res)

    if res[i]["project_id"] != need_to_see_project
      let i += 1
      continue
    endif

      let project_info.projectName = res[i]["content"]
      let project_info.id = res[i]["id"]

      if has_key(res[i],'parent_id')
        echo printf("    ・%s\n",project_info.projectName)
        let i += 1
        continue
      endif

      echo printf("・%s\n",project_info.projectName)

      let i += 1
  endwhile

endfunction


function! adtd#execCurl(action,data) abort
  let token = get(g:, 'adtd_token', '')

  if a:action == 'GET'
    let curl=printf('curl -X GET -Ss https://api.todoist.com/rest/v1/tasks  -H "Authorization: Bearer %s"',token)
  endif

  if a:action == 'DELETE'
    let curl=printf('curl -X DELETE  -Ss https://api.todoist.com/rest/v1/tasks/%s  -H "Authorization: Bearer %s"',a:data,token)
  endif

  if a:action == 'ADD'
    let curl=printf('curl -X POST %s -Ss https://api.todoist.com/rest/v1/tasks  -H "Content-Type: application/json" -H "Authorization: Bearer %s"',a:data,token)
  endif

  if a:action =="GET_PROJECT"
    let curl=printf('curl -X GET -Ss https://api.todoist.com/rest/v1/projects  -H "Authorization: Bearer %s"',token)
  endif

  let res = system(curl)
  let decoded = json_decode(res)

  return decoded
endfunction


function! adtd#getAllTask(func_method) abort

  let res = adtd#execCurl('GET',0)

  let task_info = {}

  let i = 0

  while i < len(res)
    let task_info.taskName = res[i]["content"]
    let task_info.id = res[i]["id"]
    let task_info.no = i

    if has_key(res[i],'parent_id')
      echo printf("    ・%s\n",task_info.taskName)
      let i += 1
      continue
    endif

    echo printf("%s %s\n",task_info.no,task_info.taskName)
    let i += 1
  endwhile


  if a:func_method == 'delete'
    call adtd#generateDeleteTaskInfo(res)
  endif

endfunction

function! adtd#dispTask(task_info) abort
  let i = 0
  while i < len(a:task_info)
    echo printf("[%s] %s\n",a:task_info.no,a:task_info.taskName)
    let i += 1
  endwhile

endfunction

function! adtd#generateDeleteTaskInfo(decoded) abort

  let selected = input("Which one do you want to delete? ")
  let needDelId =  a:decoded[selected]["id"]

  let confirmDelete = input("\nAre you sure you want to delete? [y/n]\n")

  let method = 'DELETE'

  if confirmDelete == 'y'
    call adtd#execCurl(method,needDelId)
    echo "\nDelete complete"
  elseif confirmDelete == 'n'
    echo "\ncanceled"
  endif

endfunction


function! adtd#addTask() abort
  let taskName = input("task name :")

  let option = {
        \ "content" : taskName,
        \}

  let json_data =printf("--data '%s'",json_encode(option))

  let decoded_res = adtd#execCurl("ADD",json_data)

  echo "\ncreated task :".'name :'. decoded_res["content"].' '.'url :'.decoded_res["url"]

endfunction

