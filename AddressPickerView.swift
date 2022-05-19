//
//  AddressPickerView.swift
//  HdsContract
//
//  Created by 中战云台 on 2022/5/19.
//

import SwiftUI

class AddressPickerModel: ObservableObject{
    
    var provincesJson = [AddrProvince]() {
        didSet {
            guard provincesJson.count > 0 else { return }
            self.provinces = provincesJson.map{
                return $0.name!
            }
        }
    }
    
    @Published var provinces = ["广东省","广东2省"]
    @Published var citys = ["深圳市"]
    @Published var araes = ["南山区"]
    
    @Published var araeSelection = 0
    
    @Published var provinceSelection = 0 {
        didSet {
            
            guard provincesJson.count > 0 else { return }
            self.citys = provincesJson[provinceSelection].city!.map{
                return $0.name!
            }
            citySelection = 0
            araeSelection = 0
        }
    }
    @Published var citySelection = 0 {
        didSet {guard provincesJson.count > 0 else { return }
            self.araes = provincesJson[provinceSelection].city![citySelection].area!
            
            araeSelection = 0

        }
    }
}

struct AddressPickerView: View {
    
    @StateObject var viewModel = AddressPickerModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack(spacing: 0) {
                    Picker(selection: $viewModel.provinceSelection, label: Text("")) {
                        
                        ForEach(viewModel.provinces.indices,id:\.self){ index in
                            Text("\(viewModel.provinces[index])").tag(index)
                        }
                        //                        ForEach(0 ..< self.provinces.count) { index in
                        //                            Text("\(self.provinces[index])").tag(index)
                        //                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width/3, height: geometry.size.height / 3, alignment: .center)
                    .compositingGroup()
                    .clipped()
                    
                    
                    Picker(selection: $viewModel.citySelection, label: Text("")) {
                        ForEach(viewModel.citys.indices,id:\.self){ index in
                            Text("\(viewModel.citys[index])").tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width/3, height: geometry.size.height / 3, alignment: .center)
                    .compositingGroup()
                    .clipped()
                    .id("c")
                    Picker(selection: $viewModel.araeSelection, label: Text("")) {
                        ForEach(viewModel.araes.indices,id:\.self){ index in
                            Text("\(viewModel.araes[index])").tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width/3, height: geometry.size.height / 3, alignment: .center)
                    .compositingGroup()
                    .clipped()
                    .id("a")
                }
                Text("Remind me in \(viewModel.provinceSelection) p (s), \(viewModel.citySelection) c (s) and \(viewModel.araeSelection) a(s)")
                    .padding(.top)
            }
            .onViewDidLoad {
                fetchJson()
            }
        }
    }
    
    private func fetchJson(){
        
        guard let path = Bundle.main.path(forResource: "province", ofType: "json") else { return }
        let localData = NSData.init(contentsOfFile: path)! as Data
        do {
            
            let addrs = try JSONDecoder().decode([AddrProvince].self, from: localData)
            viewModel.provincesJson = addrs
            viewModel.provinceSelection = 0
        } catch {
            debugPrint("\(error)===ERROR")
        }
        
    }
}

struct AddrProvince: Codable {
    var name: String?
    var city: [AddrCity]?
}

// MARK: - City
struct AddrCity: Codable {
    var name: String?
    var area: [String]?
}

struct AddressPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AddressPickerView()
    }
}
