/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2020-2021
 * Carrascado 2022
 *
 * This file is part of Gearbox.
 *
 * Gearbox is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Gearbox is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Gearbox.  If not, see <https://www.gnu.org/licenses/>.
 */

class gb_Options
{

  static
  gb_Options from()
  {
    let result = new("gb_Options");

    result.mScale                  = gb_Cvar.from("gb_scale");
    result.mColor                  = gb_Cvar.from("gb_color");
    result.mDimColor               = gb_Cvar.from("gb_dim_color");
    result.mViewType               = gb_Cvar.from("gb_view_type");
    result.mIsDimEnabled           = gb_Cvar.from("gb_enable_dim");
    result.mIsBlurEnabled          = gb_Cvar.from("gb_enable_blur");
    result.mWheelTint              = gb_Cvar.from("gb_wheel_tint");
    result.mMultiWheelLimit        = gb_Cvar.from("gb_multiwheel_limit");
    result.mShowTags               = gb_Cvar.from("gb_show_tags");
    result.mShowWeaponTagsOnChange = gb_Cvar.from("DisplayNameTags");
    result.mIsPositionLocked       = gb_Cvar.from("gb_lock_positions");
    result.mFrozenCanOpen          = gb_Cvar.from("gb_frozen_can_open");
    result.mPreserveAspectRatio    = gb_Cvar.from("hud_AspectScale");

    result.mOpenOnScroll           = gb_Cvar.from("gb_open_on_scroll");
    result.mOpenOnSlot             = gb_Cvar.from("gb_open_on_slot");
    result.mReverseSlotCycleOrder  = gb_Cvar.from("gb_reverse_slot_cycle_order");
    result.mSelectFirstSlotWeapon  = gb_Cvar.from("gb_select_first_slot_weapon");
    result.mMouseInWheel           = gb_Cvar.from("gb_mouse_in_wheel");
    result.mSelectOnKeyUp          = gb_Cvar.from("gb_select_on_key_up");
    result.mNoMenuIfOne            = gb_Cvar.from("gb_no_menu_if_one");
    result.mTimeFreeze             = gb_Cvar.from("gb_time_freeze");
    result.mOnAutomap              = gb_Cvar.from("gb_on_automap");
    result.mEnableSounds           = gb_Cvar.from("gb_enable_sounds");

    result.mMouseSensitivityX      = gb_Cvar.from("gb_mouse_sensitivity_x");
    result.mMouseSensitivityY      = gb_Cvar.from("gb_mouse_sensitivity_y");
    result.mInvertMouseX           = gb_Cvar.from("invertMouseX");
    result.mInvertMouseY           = gb_Cvar.from("invertMouse");

    result.mBlocksPositionX        = gb_Cvar.from("gb_blocks_position_x");
    result.mBlocksPositionY        = gb_Cvar.from("gb_blocks_position_y");

    result.mTextScale              = gb_Cvar.from("gb_text_scale");
    result.mTextPositionX          = gb_Cvar.from("gb_text_position_x");
    result.mTextPositionY          = gb_Cvar.from("gb_text_position_y");
    result.mTextPositionYMax       = gb_Cvar.from("gb_text_position_y_max");
    result.mTextUsualColor         = gb_Cvar.from("gb_text_usual_color");
    result.mTextSelectedColor      = gb_Cvar.from("gb_text_selected_color"); 
	result.mColoredUi      		   = gb_Cvar.from("gb_colored_ui");
	
    result.mWheelPosition          = gb_Cvar.from("gb_wheel_position");
    result.mWheelScale             = gb_Cvar.from("gb_wheel_scale");

    return result;
  }

  int  getViewType()                 const { return mViewType              .getInt();     }
  int  getScale()                    const { return mScale                 .getInt();     }
  int  getColor()                    const { return mColor                 .getInt();     }
  int  getDimColor()                 const { return mDimColor              .getInt();     }
  bool isDimEnabled()                const { return mIsDimEnabled          .getBool();    }
  bool isBlurEnabled()               const { return mIsBlurEnabled         .getBool();    }
  bool getWheelTint()                const { return mWheelTint             .getBool();    }
  int  getMultiWheelLimit()          const { return mMultiWheelLimit       .getInt();     }
  bool isShowingTags()               const { return mShowTags              .getBool();    }
  bool isShowingWeaponTagsOnChange() const { return mShowWeaponTagsOnChange.getInt() & 2; }
  bool isPositionLocked()            const { return mIsPositionLocked      .getBool();    }
  bool isFrozenCanOpen()             const { return mFrozenCanOpen         .getBool();    }
  bool isPreservingAspectRatio()     const { return mPreserveAspectRatio   .getBool();    }

  bool isOpenOnScroll()              const { return mOpenOnScroll          .getBool();    }
  bool isOpenOnSlot()                const { return mOpenOnSlot            .getBool();    }
  bool isSlotCycleOrderReversed()    const { return mReverseSlotCycleOrder .getBool();    }
  bool isSelectFirstSlotWeapon()     const { return mSelectFirstSlotWeapon .getBool();    }
  bool isMouseInWheel()              const { return mMouseInWheel          .getBool();    }
  bool isSelectOnKeyUp()             const { return mSelectOnKeyUp         .getBool();    }
  bool isNoMenuIfOne()               const { return mNoMenuIfOne           .getBool();    }
  bool isOnAutomap()                 const { return mOnAutomap             .getBool();    }
  bool isSoundEnabled()              const { return mEnableSounds          .getBool();    }
  
  bool isColoredEnabled()			 const { return mColoredUi             .getBool();    }

  int  getTimeFreezeMode()           const { return mTimeFreeze            .getInt();     }

  vector2 getMouseSensitivity() const
  {
    double xDirection = mInvertMouseX.getBool() ? -1 : 1;
    double yDirection = mInvertMouseY.getBool() ? -1 : 1;
    return ( mMouseSensitivityX.getDouble() * xDirection
           , mMouseSensitivityY.getDouble() * yDirection
           );
  }

  vector2 getBlocksPosition() const
  {
    return (mBlocksPositionX.getDouble(), mBlocksPositionY.getDouble());
  }

  int getTextScale()           const { return mTextScale        .getInt();   }
  int getTextUsualColor()      const { return mTextUsualColor   .getInt();   }
  int getTextSelectedColor()   const { return mTextSelectedColor.getInt();   }
  double getTextPositionYMax() const { return mTextPositionYMax.getDouble(); }

  vector2 getTextPosition() const
  {
    return (mTextPositionX.getDouble(), mTextPositionY.getDouble());
  }


  double getWheelPosition() const { return mWheelPosition.getDouble(); }
  double getWheelScale()    const { return mWheelScale.getDouble(); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private gb_Cvar mScale;
  private gb_Cvar mColor;
  private gb_Cvar mDimColor;
  private gb_Cvar mViewType;
  private gb_Cvar mIsDimEnabled;
  private gb_Cvar mIsBlurEnabled;
  private gb_Cvar mWheelTint;
  private gb_Cvar mMultiWheelLimit;
  private gb_Cvar mShowTags;
  private gb_Cvar mShowWeaponTagsOnChange;
  private gb_Cvar mIsPositionLocked;

  private gb_Cvar mOpenOnScroll;
  private gb_Cvar mOpenOnSlot;
  private gb_Cvar mReverseSlotCycleOrder;
  private gb_Cvar mSelectFirstSlotWeapon;
  private gb_Cvar mMouseInWheel;
  private gb_Cvar mSelectOnKeyUp;
  private gb_Cvar mNoMenuIfOne;
  private gb_Cvar mTimeFreeze;
  private gb_Cvar mOnAutomap;
  private gb_Cvar mEnableSounds;
  private gb_Cvar mFrozenCanOpen;
  private gb_Cvar mPreserveAspectRatio;

  private gb_Cvar mMouseSensitivityX;
  private gb_Cvar mMouseSensitivityY;

  private gb_Cvar mInvertMouseX;
  private gb_Cvar mInvertMouseY;

  private gb_Cvar mBlocksPositionX;
  private gb_Cvar mBlocksPositionY;

  private gb_Cvar mTextScale;
  private gb_Cvar mTextPositionX;
  private gb_Cvar mTextPositionY;
  private gb_Cvar mTextPositionYMax;
  private gb_Cvar mTextUsualColor;
  private gb_Cvar mTextSelectedColor;
  private gb_Cvar mColoredUi;

  private gb_Cvar mWheelPosition;
  private gb_Cvar mWheelScale;

} // class gb_Options
