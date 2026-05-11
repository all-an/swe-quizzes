package com.swequizzes.settings;

import org.springframework.stereotype.Service;

@Service
public class SettingsService {
    private final SettingsRepository settingsRepository;

    public SettingsService(SettingsRepository settingsRepository) {
        this.settingsRepository = settingsRepository;
    }

    public Settings current() {
        return settingsRepository.findById(1L).orElseGet(() -> {
            Settings settings = new Settings();
            settings.setId(1L);
            settings.setDisableLogin(false);
            settings.setDisableRegister(false);
            return settingsRepository.save(settings);
        });
    }

    public Settings update(SettingsRequest request) {
        Settings settings = current();
        settings.setDisableLogin(request.disableLogin());
        settings.setDisableRegister(request.disableRegister());
        return settingsRepository.save(settings);
    }
}
