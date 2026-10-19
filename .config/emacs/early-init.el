;;; early-init.el --- Runs before the first frame and package.el  -*- lexical-binding: t; -*-

;; Raise the GC threshold during startup; init.el lowers it again.
(setq gc-cons-threshold most-positive-fixnum)

;; We call `package-initialize' ourselves in init.el.
(setq package-enable-at-startup nil)

;; Strip UI chrome before the frame is drawn to avoid flicker.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq inhibit-startup-screen t)

;; Keep native-comp warnings out of the way.
(setq native-comp-async-report-warnings-errors 'silent)
