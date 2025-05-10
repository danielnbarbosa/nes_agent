import gymnasium as gym
import retro
import matplotlib.pyplot as plt
from sample_factory.envs.env_wrappers import (
    ClipRewardEnv,
    EpisodicLifeEnv,
    FireResetEnv,
    MaxAndSkipEnv,
    NoopResetEnv,
    NumpyObsWrapper,
    RewardScalingWrapper,
)


class CropObservation(gym.ObservationWrapper):
    def __init__(self, env, top, left, height, width):
        super().__init__(env)
        self.top = top
        self.left = left
        self.height = height
        self.width = width
        orig_shape = env.observation_space.shape  # (H, W, C)
        new_shape = (height, width, orig_shape[2])
        self.observation_space = gym.spaces.Box(
            low=0,
            high=255,
            shape=new_shape,
            dtype=env.observation_space.dtype
        )
    def observation(self, obs):
        return obs[self.top:self.top+self.height, self.left:self.left+self.width, :]


env = retro.make('DoubleDragon-Nes', state='Stage2-1-1')
#env = NoopResetEnv(env, noop_max=30)
#env = MaxAndSkipEnv(env, skip=4)
#env = CropObservation(env, top=0, left=0, height=190, width=240)
#env = gym.wrappers.ResizeObservation(env, (84, 84))
#env = gym.wrappers.GrayScaleObservation(env)
#env = gym.wrappers.FrameStack(env, 4)
#env = NumpyObsWrapper(env)

obs, info = env.reset()
plt.imshow(obs)
plt.show()
