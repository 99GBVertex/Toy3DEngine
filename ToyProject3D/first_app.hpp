#pragma once

#include "GraphicsCore/VulkanRHI/lve_device.hpp"
#include "GraphicsCore/VulkanRHI/lve_game_object.hpp"
#include "GraphicsCore/VulkanRHI/lve_renderer.hpp"
#include "GraphicsCore/VulkanRHI/lve_window.hpp"
#include "GraphicsCore/VulkanRHI/lve_descriptors.hpp"

// std
#include <memory>
#include <vector>

namespace lve {
class FirstApp {
 public:
  static constexpr int WIDTH = 800;
  static constexpr int HEIGHT = 600;

  FirstApp();
  ~FirstApp();

  FirstApp(const FirstApp &) = delete;
  FirstApp &operator=(const FirstApp &) = delete;

  void run();

 private:
  void loadGameObjects();
  void makeGridObject();

  LveWindow lveWindow{WIDTH, HEIGHT, "Vulkan Tutorial"};
  LveDevice lveDevice {lveWindow};
  LveRenderer lveRenderer {lveWindow, lveDevice};

  std::shared_ptr<LveTexture> defaultTexture;

  // note: order of declarations matters
  std::unique_ptr<LveDescriptorPool> globalPool{};
  std::vector<LveGameObject> gameObjects;
  std::unique_ptr<LveGameObject> gridObject{};
};
}  // namespace lve
