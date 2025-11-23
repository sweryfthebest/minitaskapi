package com.example.minitaskapi.controller; // DİKKAT: Paket adı 'controller' olarak değişti.

import com.example.minitaskapi.model.Task; // Task modelini import etmeyi unutmayın!
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;

// @RestController ve tüm GET/POST/PUT/DELETE metodlarının olduğu kodun tamamını buraya yapıştırın.

@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    // ... (Geri kalan tüm metotları buraya yapıştırın) ...
    private final List<Task> tasks = new ArrayList<>();
    private final AtomicLong counter = new AtomicLong();

    public TaskController() {
        tasks.add(new Task(counter.incrementAndGet(), "Spring Boot projesini tamamla", false));
        tasks.add(new Task(counter.incrementAndGet(), "Postman testlerini hazırla", true));
    }
    
    @GetMapping
    public List<Task> getAllTasks() {
        return tasks;
    }
    // ... (Diğer tüm CRUD metotları) ...
    @GetMapping("/{id}")
    public ResponseEntity<Task> getTaskById(@PathVariable Long id) {
        Optional<Task> task = tasks.stream()
                .filter(t -> t.getId().equals(id))
                .findFirst();
        return task.map(ResponseEntity::ok)
                   .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public Task addTask(@RequestBody Task newTask) {
        newTask.setId(counter.incrementAndGet());
        tasks.add(newTask);
        return newTask;
    }

    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id, @RequestBody Task updatedTask) {
        for (int i = 0; i < tasks.size(); i++) {
            if (tasks.get(i).getId().equals(id)) {
                Task existingTask = tasks.get(i);
                existingTask.setTitle(updatedTask.getTitle());
                existingTask.setCompleted(updatedTask.isCompleted());
                return ResponseEntity.ok(existingTask);
            }
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        boolean removed = tasks.removeIf(t -> t.getId().equals(id));
        if (removed) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}