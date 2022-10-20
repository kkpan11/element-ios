//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

struct UserOtherSessions: View {
    @Environment(\.theme) private var theme
    
    @ObservedObject var viewModel: UserOtherSessionsViewModel.Context
    
    var body: some View {
        ScrollView {
            SwiftUI.Section {
                if viewModel.viewState.items.isEmpty {
                    VStack {
                        Text(viewModel.viewState.emptyItemsTitle)
                            .font(theme.fonts.footnote)
                            .foregroundColor(theme.colors.primaryContent)
                            .padding(.bottom, 20)
                        Button {
                            viewModel.send(viewAction: .clearFilter)
                        } label: {
                            VStack(spacing: 0) {
                                SeparatorLine()
                                Text(VectorL10n.userOtherSessionClearFilter)
                                    .font(theme.fonts.body)
                                    .foregroundColor(theme.colors.accent)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 11)
                                SeparatorLine()
                            }
                            .background(theme.colors.background)
                        }
                    }
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.viewState.items) { viewData in
                            UserSessionListItem(viewData: viewData, isEditModeEnabled: viewModel.isEditModeEnabled, onBackgroundTap: { sessionId in
                                viewModel.send(viewAction: .userOtherSessionSelected(sessionId: sessionId))
                            })
                        }
                    }
                    .background(theme.colors.background)
                }
            } header: {
                UserOtherSessionsHeaderView(viewData: viewModel.viewState.header)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24.0)
            }
        }
        .background(theme.colors.system.ignoresSafeArea())
        .frame(maxHeight: .infinity)
        .navigationTitle(viewModel.viewState.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("", selection: $viewModel.filter) {
                        ForEach(UserOtherSessionsFilter.allCases) { filter in
                            Text(filter.menuLocalizedName).tag(filter)
                        }
                    }
                    .labelsHidden()
                    .onChange(of: viewModel.filter) { _ in
                        viewModel.send(viewAction: .filterWasChanged)
                    }
                } label: {
                    Image(viewModel.filter == .all ? Asset.Images.userOtherSessionsFilter.name : Asset.Images.userOtherSessionsFilterSelected.name)
                }
                .offset(x: 7)
                .accessibilityLabel(VectorL10n.userOtherSessionFilter)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        viewModel.isEditModeEnabled.toggle()
                    } label: {
                        Label(VectorL10n.userOtherSessionMenuSelectSessions, systemImage: "checkmark.circle")
                    }
                    .onChange(of: viewModel.isEditModeEnabled) { _ in
                        viewModel.send(viewAction: .editModeWasToggled)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(.horizontal, 4)
                        .padding(.vertical, 12)
                }
                .offset(x: 4)
            }
        }
        .accentColor(theme.colors.accent)
    }
}

// MARK: - Previews

struct UserOtherSessions_Previews: PreviewProvider {
    static let stateRenderer = MockUserOtherSessionsScreenState.stateRenderer
    
    static var previews: some View {
        stateRenderer.screenGroup(addNavigation: true).theme(.light).preferredColorScheme(.light)
        stateRenderer.screenGroup(addNavigation: true).theme(.dark).preferredColorScheme(.dark)
    }
}
