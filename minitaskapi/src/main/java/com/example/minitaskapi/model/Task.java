package com.example.minitaskapi.model; // DİKKAT: Paket adı 'model' olarak değişti.

public class Task {
    private Long id;
    private String title;
    private boolean completed;

    // Constructors, Getters ve Setters (Daha önceki yanıtta verilen kodun tamamını buraya yapıştırın.)

    public Task() {
    }

    public Task(Long id, String title, boolean completed) {
        this.id = id;
        this.title = title;
        this.completed = completed;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }
}