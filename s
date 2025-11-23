<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MiniTask API</title>
    <style>
        /* CSS: Siyah/Yeşil Neon Tema ve Kavisli Tasarım */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #1a1a1a; /* Koyu Siyah Tema */
            color: #e0e0e0;
        }
        .container {
            max-width: 650px;
            margin: 50px auto;
            background: #252525;
            padding: 30px;
            border-radius: 15px; /* Kavisli Köşeler */
            /* Neon Işık Efekti (Yeşil) */
            box-shadow: 0 0 20px rgba(0, 255, 0, 0.4), 
                        0 0 40px rgba(0, 255, 0, 0.1);
        }
        h1 {
            color: #00ff00; /* Neon Yeşil Başlık */
            text-align: center;
            text-shadow: 0 0 5px #00ff00;
        }
        p {
            text-align: center;
            font-size: 0.9em;
            color: #888;
        }
        input[type="text"], button {
            padding: 12px;
            border-radius: 8px;
            font-size: 16px;
        }
        input[type="text"] {
            width: 70%;
            margin-right: 10px;
            background-color: #333;
            border: 1px solid #00ff00; /* Neon Kenarlık */
            color: white;
            box-shadow: 0 0 5px rgba(0, 255, 0, 0.5); /* Hafif İç Gölge */
        }
        button {
            background-color: #00ff00;
            color: #1a1a1a;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #00cc00;
        }
        ul {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }
        li {
            background: #333;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            border-left: 5px solid #00ff00; /* Neon Çizgi */
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
        }
        .completed {
            border-left: 5px solid #0066ff; /* Tamamlandı rengi (Mavi Neon) */
            background: #1f1f1f;
            color: #888;
        }
        .status-icon {
            font-size: 20px;
            margin-left: 15px;
        }
        .completed .status-icon {
            color: #0066ff; /* Mavi tik */
        }
        #statusMessage {
            color: #00ff00;
            text-shadow: 0 0 2px #00ff00;
            margin-top: 15px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>MiniTask API</h1>
        <p>Spring Boot İle İletişim Kuruldu.</p>
        
        <div>
            <input type="text" id="taskInput" placeholder="Yeni görev başlığı girin...">
            <button onclick="addTask()">Görev Ekle</button>
        </div>

        <p id="statusMessage"></p>
        <hr style="border-top: 1px dashed #444; margin-top: 20px;">

        <h2>Mevcut Görevler</h2>
        <ul id="taskList">
            </ul>
    </div>

    <script>
        // JavaScript: API Bağlantısı ve Mantık
        const API_URL = '/api/tasks'; // API, aynı sunucuda olduğu için sadece yolu kullandık.
        const taskList = document.getElementById('taskList');
        const statusMessage = document.getElementById('statusMessage');

        // Sayfayı yükle ve görevleri çek (READ/GET)
        async function fetchTasks() {
            try {
                const response = await fetch(API_URL);
                const tasks = await response.json();
                
                taskList.innerHTML = ''; 
                
                tasks.forEach(task => {
                    const listItem = document.createElement('li');
                    
                    const statusIcon = document.createElement('span');
                    statusIcon.classList.add('status-icon');
                    
                    // Tamamlanma durumuna göre stil ve ikon atama
                    if (task.completed) {
                        listItem.classList.add('completed');
                        statusIcon.textContent = '✅'; // Tamamlandı işareti (Mavi Neon)
                    } else {
                        statusIcon.textContent = '⏳'; // Beklemede işareti (Varsayılan Yeşil)
                    }
                    
                    const taskText = document.createTextNode(`[ID: ${task.id}] ${task.title}`);

                    listItem.appendChild(taskText);
                    listItem.appendChild(statusIcon);
                    taskList.appendChild(listItem);
                });

            } catch (error) {
                console.error('Görevler çekilirken hata oluştu:', error);
                taskList.innerHTML = '<li>API Sunucusuna (Spring Boot) bağlanılamıyor. Çalıştırdığınızdan emin olun!</li>';
            }
        }

        async function addTask() {
            const inputElement = document.getElementById('taskInput');
            const taskTitle = inputElement.value.trim();

            if (taskTitle === "") {
                statusMessage.textContent = 'Lütfen bir görev başlığı girin.';
                return;
            }

            const newTask = {
                title: taskTitle,
                completed: false
            };

            try {
                statusMessage.textContent = 'Göreviniz API\'ye gönderiliyor...';
                
                const response = await fetch(API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(newTask)
                });

                if (response.ok) {
                    const addedTask = await response.json();
                    statusMessage.textContent = `✅ Başarıyla eklendi! (ID: ${addedTask.id})`;
                    inputElement.value = ''; // Girişi temizle
                    fetchTasks(); // Listeyi yenile
                } else {
                    statusMessage.textContent = 'API hata verdi: ' + response.status;
                }

            } catch (error) {
                console.error('Görev eklenirken hata oluştu:', error);
                statusMessage.textContent = '❌ Bağlantı hatası! Spring Boot sunucusu çalışmıyor.';
            }
        }

        // Sayfa yüklendiğinde görevleri çek
        window.onload = fetchTasks;

    </script>

</body>
</html>
